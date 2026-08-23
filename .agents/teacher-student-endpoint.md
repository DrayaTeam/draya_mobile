# Frontend & Mobile Implementation Guide: Weakness & Teacher Review API

This guide provides the necessary details for implementing the new Teacher Review flow and the dynamically tracked Student Weakness system on both Web (Frontend) and Mobile clients.

## 1. Teacher Attempt Review Flow (Per-Answer Override)

The backend now fully supports a per-answer, authoritative grading flow. Teachers can override specific answers rather than approving the entire exam.

### Step 1.1: Dashboard / Attempts List
The endpoint to fetch a classroom's exam attempts now flags attempts that require teacher intervention.

**Endpoint:** `GET /api/v1/exams/{examId}/attempts?page=1&pageSize=10`
**Roles:** `Teacher`

**New Field:** `NeedsTeacherReview`
- **Action:** If `NeedsTeacherReview` is `true`, display an **"Action Required"** or **"Needs Review"** badge next to the attempt in the list.

### Step 2: Attempt Details & Scoring
When the teacher opens an attempt to review it, fetch the attempt results. The payload has been enriched to provide all necessary context (Question Text, Rubric) so you do not need to fetch the exam again.

**Endpoint:** `GET /api/v1/attempts/{attemptId}/results`
**Roles:** `Teacher`, `Student`

**Updated Payload Highlights:**
- **Exam Info:** Added `ExamTitle` and `MaxScore` at the root level.
- **Answer Array:** Now contains `QuestionText`, `QuestionType`, and `Rubric`.
- **Grading Result:** 
  - `IsFinalized`: Indicates if the answer's score is locked in. (Deterministic AI questions are finalized automatically).
  - `NeedsTeacherReview`: If true, the AI flagged this for review.
  - `ReviewedByTeacherId` & `TeacherOverrideScore`: Indicates a teacher has already stepped in.

**UI Implementation:**
- Loop through the `Answers` array.
- If `NeedsTeacherReview == true` and `IsFinalized == false`, highlight this answer. Show the `QuestionText`, `Rubric`, `AnswerText`, AI `Score`, and AI `Rationale`.
- Provide an input field for the teacher to enter a new score.

### Step 3: Submitting an Override
When the teacher saves a new score for an answer, send a PUT request.

**Endpoint:** `PUT /api/v1/attempts/{attemptId}/answers/{answerId}/override`
**Roles:** `Teacher`
**Body:** `{ "newScore": 4.5 }`

> [!IMPORTANT]  
> **Backend Authority:** You do not need to calculate the final attempt score or trigger weakness updates. As soon as you call this override endpoint, the backend recalculates the final exam score and automatically updates the student's weaknesses if all reviews for the attempt are complete.

---

## 2. Student Views (Exam & Weaknesses)

### 2.1 Student Exam View
A new endpoint to fetch an exam along with the student's attempt history in one call.

**Endpoint:** `GET /api/v1/exams/{examId}/student-view`
**Roles:** `Student`

**Returns:**
```json
{
  "Exam": { "Id": "...", "Title": "...", "QuestionsCount": 10 },
  "Attempts": [
    { "Id": "...", "FinalScore": 8.5, "NeedsTeacherReview": false, "SubmittedAt": "..." }
  ]
}
```

### 2.2 All Student Exams with Attempts
We also updated the endpoint to fetch **all** exams for a student, returning each exam along with an embedded list of its attempts.

**Endpoint:** `GET /api/v1/students/exams`
**Roles:** `Student`

**Returns (Paginated):**
```json
{
  "Items": [
    {
      "Id": "...",
      "Title": "Algebra Basics",
      "LatestScore": 8.5,
      "UsedAttempts": 2,
      "Attempts": [
        { "Id": "...", "FinalScore": 6.0, "NeedsTeacherReview": false, "SubmittedAt": "2026-08-20T10:00:00Z" },
        { "Id": "...", "FinalScore": 8.5, "NeedsTeacherReview": false, "SubmittedAt": "2026-08-22T14:30:00Z" }
      ]
    }
  ],
  "Page": 1,
  "PageSize": 20,
  "TotalCount": 15
}
```

### 2.2 Weaknesses Tracking
Weaknesses are now tracked as a continuous metric (`StudentWeakness`) instead of discrete snapshot records, accurately recording proficiency improvements.

**Endpoints:**
- `GET /api/v1/weaknesses/active` -> Returns weaknesses currently below mastery threshold.
- `GET /api/v1/weaknesses/resolved` -> Returns weaknesses that the student successfully improved. Includes `Delta` and `PreviousProficiencyPercent` to show improvement (e.g., "Improved by +43%").

### 2.4 Interactive AI Reviews & "Caching"
When a student wants to practice or review a weakness, they fetch the AI Review. This review is intelligently **cached** by the backend and tied to the specific version of their weakness.

**Endpoint:** `GET /api/v1/reports/interactive-review?topicName={TopicName}` 

- The AI explanation (`AiExplanation`) is only generated if no valid `WeaknessReview` exists. Otherwise, it instantly returns the cached version from the database.

---

## 3. Authentication: 6-Digit OTP

**Endpoint:** `POST /api/v1/auth/request-password-reset` & `POST /api/v1/auth/confirm-password-reset`
**Update:** The token generated and emailed is now a 6-digit OTP (e.g., `481923`) instead of a long URL-safe hash.
- Update your reset UI to present a 6-digit PIN input screen rather than looking for a hash in a query parameter.
