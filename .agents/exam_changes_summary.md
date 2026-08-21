# Detailed API & Backend Updates: Exam Constraints & Generation

This document serves as a comprehensive technical guide detailing all backend changes made to the Exam domain. It is intended for both the frontend team (to understand new DTO fields and endpoint behaviors) and the backend team (to understand architecture and validation rules).

## 1. Schema & Domain Updates

The core `Exam` entity and corresponding database tables have been expanded to support granular time constraints and attempt limits.

**New Database Columns (`Exams` Table):**
- `DurationMinutes` (int, NOT NULL, Default: 0)
- `StartDate` (datetime2, NOT NULL, Default: '0001-01-01T00:00:00.0000000')
- `EndDate` (datetime2, NULL)
- `AllowedAttempts` (int, NOT NULL, Default: 0)

> [!NOTE]
> These schema changes were applied via the EF Core migration `20260820200846_AddExamStartEndAttempts`.

---

## 2. Frontend API Contracts

### 🔹 `GET /api/v1/exams` (Classroom Exams List)

**Changes:** The endpoint response items now contain the new constraint fields.
**Usage:** The frontend must use `StartDate` and `EndDate` to determine if an exam is "Active", "Upcoming", or "Expired", and `DurationMinutes` to initialize the frontend countdown timer.

**Example Response Payload:**
```json
{
  "items": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "title": "Auto-Generated Exam: Biology Chapter 1",
      "topic": "Biology Chapter 1",
      "durationMinutes": 60,
      "startDate": "2026-08-21T10:00:00Z",
      "endDate": "2026-08-25T10:00:00Z",
      "allowedAttempts": 2,
      "createdAt": "2026-08-20T12:00:00Z",
      "questionsCount": 25
    }
  ],
  "totalCount": 1
}
```

---

## 3. Strict Backend Validations (Enforcement)

To prevent cheating or bypassing UI constraints, the backend now strictly enforces all time and attempt limits during the exam lifecycle.

### 🔹 `POST /api/v1/attempts/start` (Starting an Exam)

When a student clicks "Start Exam", the backend verifies they are legally allowed to begin.

**Validation Rules:**
1. **Not Started Yet:** `DateTime.UtcNow < exam.StartDate` 
   - **Error:** `Throws Exception: "The exam has not started yet."`
2. **Expired Exam:** `exam.EndDate != null && DateTime.UtcNow > exam.EndDate`
   - **Error:** `Throws Exception: "The exam has already ended."`
3. **Max Attempts Reached:** `existingAttemptsCount >= exam.AllowedAttempts`
   - **Error:** `Throws Exception: "You have reached the maximum allowed attempts (X) for this exam."`

> [!IMPORTANT]
> The frontend should proactively disable the "Start Exam" button if these conditions are met locally, but the backend serves as the final source of truth.

### 🔹 `POST /api/v1/attempts/{attemptId}/submit` (Submitting an Exam)

When a student submits their exam (or the frontend auto-submits when the timer expires), the backend verifies the submission is on time.

**Validation Rules:**
1. **Duration Enforcement:** 
   - Calculation: `attempt.StartedAt.AddMinutes(exam.DurationMinutes).AddMinutes(2)` (Includes a 2-minute grace period for network latency).
   - Condition: If `DateTime.UtcNow > maxEndTime`, the submission is completely rejected.
   - **Error:** `Throws Exception: "Exam duration has expired. Late submissions are not allowed."`
2. **End Date Enforcement:**
   - Calculation: `exam.EndDate.Value.AddMinutes(2)`
   - Condition: If `DateTime.UtcNow > maxEndDate`, the submission is rejected.
   - **Error:** `Throws Exception: "The exam end date has passed. Late submissions are not allowed."`

> [!WARNING]
> There are **no late submissions**. If the frontend fails to submit before the timer + 2-minute grace period expires, the student's work will not be saved or graded. The frontend must ensure reliable auto-submission exactly when the timer hits zero.

---

## 4. Exam Generation Logic (AI Integration)

The `POST /api/v1/exams/generate` endpoint kicks off an asynchronous background task (`ExamGenerationService`). This service was heavily upgraded to handle massive exam generations (e.g., 100+ questions) safely.

### 🧠 Batch Slicing Algorithm
LLM token limits and timeouts prevent generating 100 questions in a single API call.
- **Batch Size:** Hardcoded to exactly **15 questions per batch**.
- **Example:** If 105 questions are requested, the service automatically splits this into **7 distinct LLM API calls**.

### 📚 Smart Context Distribution (RAG)
Generating 105 questions from the exact same PDF chunk results in repetitive questions.
- **Algorithm:** The service divides the retrieved RAG chunks (from Qdrant) evenly across the batches. 
- **Example:** If 45 PDF chunks are retrieved for 3 batches (45 questions), Batch 1 gets chunks 1-15, Batch 2 gets chunks 16-30, and Batch 3 gets chunks 31-45. This guarantees maximum question diversity.

### 🛡️ Graceful Failure & Hallucination Handling
- If the LLM hallucinates (e.g., outputs malformed JSON or plain text instead of the requested schema) for a specific batch, the service will **catch the error, skip that batch, and continue to the next**.
- The service will save all successfully generated questions from the valid batches.
- The generation status will be marked as `CompletedWithWarning` with a message like *"Only generated 85 valid questions"* instead of crashing the entire task.

---

## 5. Additional Endpoints & Bug Fixes

- **Classroom Students:** `GET /api/v1/classrooms/{id}/students` now returns the `ProfilePictureUrl` for each student via `StudentRosterItemDto`.
- **Classroom Feedback 500 Fix:** The endpoint `GET /api/v1/classrooms/{id}/feedback` was fixed. It previously threw a `500 Internal Server Error` when a classroom had zero feedback due to an empty dictionary lookup. It now features an early exit and successfully returns an empty list with `averageRating: 0`.
