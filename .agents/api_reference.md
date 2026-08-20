# Exam & Grading API Reference

> All endpoints require a valid JWT Bearer token in the `Authorization` header.
> Base URL: `https://localhost:7040/api/v1`

---

## Overview: The Full Flow

```
TEACHER                             STUDENT                          BACKGROUND
  │                                    │                                  │
  ├─ POST /exams/generate               │                                  │
  │   └─ returns GenerationId           │                                  │
  │                                    │                                  │
  ├─ (poll) GET /exams/generations/{id} │                               [Agent 1]
  │   └─ status: Completed + examId     │                            Generates exam
  │                                    │                             via LLM + RAG
  ├─ GET /exams/{examId}                │                                  │
  │   └─ full exam with questions       │                                  │
  │                                    │                                  │
  ├─ (optional editing)                 │                                  │
  │   POST   /exams/{id}/questions      │                                  │
  │   PUT    /exams/{id}/questions/{qId}│                                  │
  │   DELETE /exams/{id}/questions/{qId}│                                  │
  │   POST   /exams/{id}/questions/{qId}/refine                            │
  │                                    │                                  │
  │                              POST /attempts/start                      │
  │                              └─ returns AttemptId                      │
  │                                    │                                  │
  │                              POST /attempts/{id}/submit                │
  │                              └─ returns GradingJobId             [Agent 2]
  │                                    │                           Grades answers:
  │                              (poll) GET /attempts/jobs/{jobId}  - Objective: instant
  │                              └─ status: Completed/Warning       - Essay: LLM + PII
  │                                    │                                  │
  │                              GET /attempts/{id}/results                │
  │                              └─ full scores + rationale                │
  │                                    │                                  │
  ├─ (if NeedsTeacherReview)            │                                  │
  │   PUT /attempts/{id}/answers/{aId}/override                            │
```

---

## 🎓 TEACHER FLOW — Exam Generation & Editing

### 1. Generate Exam
**`POST /api/v1/exams/generate`** | Role: `Teacher`

Starts an async AI exam generation job. The exam is built in the background using RAG (course materials) and LLM.

**Request Body:**
```json
{
  "classroomId": "4a3e4008-90fb-490a-87aa-5fa5d631608e",
  "sectionId": "43595b29-c80d-4930-8a44-8b86aabe927f",
  "topic": "storage in docker",
  "difficultyLevel": "easy",
  "questionRequirements": [
    { "type": "MCQ", "count": 3 },
    { "type": "Essay", "count": 2 }
  ],
  "teacherInstructions": "Focus on practical usage",
  "idempotencyKey": "unique-key-per-request-001"
}
```

> **`idempotencyKey`** — Generate a UUID per generation request. If the same key is sent twice, the second call returns the existing generation ID without starting a duplicate job. Use a fresh UUID for each new exam.

**Question types:** `MCQ`, `Essay`, `TrueFalse`, `FillInTheBlank`, `ShortAnswer`

**Response: `202 Accepted`**
```json
{
  "generationId": "8ec7018a-0e4c-4e60-9f8b-df224dd8a7e6",
  "message": "Exam generation has started in the background. Connect to the SignalR hub '/hubs/exam-generation' to receive progress updates."
}
```

---

### 2. Poll Generation Status
**`GET /api/v1/exams/generations/{generationId}`** | Role: `Teacher`

Poll this endpoint every 2–3 seconds until `status` is not `0` (Pending) or `2` (Retrieving) or `3` (Generating).

**Response: `200 OK`**
```json
{
  "id": "8ec7018a-0e4c-4e60-9f8b-df224dd8a7e6",
  "status": 4,
  "statusName": "Completed",
  "requestedCount": 5,
  "generatedCount": 5,
  "createdAt": "2026-08-19T13:19:00.000Z",
  "completedAt": "2026-08-19T13:19:31.742Z",
  "errorMessage": null,
  "examId": "1595afe8-ff4d-42b7-a365-2c956e31fff2"
}
```

| `status` value | `statusName`         | Meaning                                  |
|---------------|----------------------|------------------------------------------|
| `0`           | `Pending`            | Waiting to start                         |
| `1`           | `Retrieving`         | Searching course materials (RAG)         |
| `2`           | `Generating`         | LLM is generating questions              |
| `3`           | `Validating`         | Validating LLM output                    |
| `4`           | `Completed`          | ✅ Done — use `examId` to view the exam  |
| `5`           | `CompletedWithWarning` | ⚠️ Fewer questions than requested       |
| `6`           | `DataUnavailable`    | No course materials found for section    |
| `7`           | `Failed`             | Error — check `errorMessage`             |

> Once `statusName` is `Completed` or `CompletedWithWarning`, read `examId` and call the next endpoint.

---

### 3. Get Exam with Questions
**`GET /api/v1/exams/{examId}`** | Role: `Teacher`

Returns the full exam with all questions, options, and rubrics.

**Response: `200 OK`**
```json
{
  "id": "1595afe8-ff4d-42b7-a365-2c956e31fff2",
  "classroomId": "4a3e4008-...",
  "sectionId": "43595b29-...",
  "title": "Auto-Generated Exam: storage in docker",
  "topic": "storage in docker",
  "createdAt": "2026-08-19T13:19:31.742Z",
  "questions": [
    {
      "id": "85ccf63c-19f9-4520-9c95-1634bf4d5ce7",
      "text": "Which command saves the current state of a container?",
      "type": "MultipleChoice",
      "difficulty": "easy",
      "rubric": null,
      "options": [
        { "id": "42c994a0-...", "text": "docker build", "isCorrect": false },
        { "id": "3742658d-...", "text": "docker commit", "isCorrect": true }
      ]
    },
    {
      "id": "3a7602d9-5090-49ab-93be-1f7881b4be86",
      "text": "Explain how you can save changes to a running container.",
      "type": "Essay",
      "difficulty": "easy",
      "rubric": "Answer should mention docker commit, container ID, and image name.",
      "options": []
    }
  ]
}
```

> **Important for frontend:** For `MCQ` and `TrueFalse` questions, show the `options` array. For `Essay` and `ShortAnswer`, show a text area. For `FillInTheBlank`, show a text input. **Do NOT show `isCorrect` to students!**

---

### 4. Teacher Editing (CRUD)

#### Add Question
**`POST /api/v1/exams/{examId}/questions`** | Role: `Teacher`
```json
{
  "text": "What is a Docker volume?",
  "type": "ShortAnswer",
  "difficulty": "easy",
  "rubric": "Should mention persistent storage independent of container lifecycle.",
  "sourceChunkIds": [],
  "options": []
}
```
**Response: `200 OK`** `{ "questionId": "new-uuid" }`

#### Update Question
**`PUT /api/v1/exams/{examId}/questions/{questionId}`** | Role: `Teacher`
```json
{
  "text": "Updated question text here",
  "type": "Essay",
  "difficulty": "medium",
  "rubric": "Updated rubric",
  "options": []
}
```
**Response: `204 No Content`**

#### Delete Question
**`DELETE /api/v1/exams/{examId}/questions/{questionId}`** | Role: `Teacher`

**Response: `204 No Content`**

#### AI Refine Question
**`POST /api/v1/exams/{examId}/questions/{questionId}/refine`** | Role: `Teacher`

Asks AI to rewrite a specific question based on a natural language instruction.

```json
{
  "instruction": "Make this question harder and scenario-based"
}
```

**Response: `200 OK`** — Returns a refined question object (not saved yet, teacher must call Update to apply it):
```json
{
  "text": "A developer notices that data is lost after restarting a container. Which Docker storage mechanism should they use to persist data?",
  "type": "MultipleChoice",
  "difficulty": "medium",
  "options": [
    { "text": "Docker volumes", "isCorrect": true },
    { "text": "Container layers", "isCorrect": false }
  ],
  "rubric": null,
  "sourceChunkIds": ["uuid-of-source-chunk"]
}
```

---

## 🧑‍🎓 STUDENT FLOW — Taking & Submitting an Exam

### 5. Start Exam Attempt
**`POST /api/v1/attempts/start`** | Role: `Student`

Student signals they're starting the exam. Records the start time.

**Request Body:**
```json
{
  "examId": "1595afe8-ff4d-42b7-a365-2c956e31fff2"
}
```

**Response: `200 OK`**
```json
{
  "attemptId": "7e0c24cf-c1ad-4d6a-adf6-ab2f2b0d53f9"
}
```

> Store the `attemptId` — you'll need it for submission and results.

---

### 6. Submit Exam (Triggers Grading)
**`POST /api/v1/attempts/{attemptId}/submit`** | Role: `Student`

Submits all answers at once. **This immediately triggers the background grading pipeline (Agent 2).**

**Request Body:**
```json
{
  "idempotencyKey": "unique-submission-key-001",
  "answers": [
    {
      "examQuestionId": "85ccf63c-19f9-4520-9c95-1634bf4d5ce7",
      "answerText": "",
      "selectedOptionId": "3742658d-c1df-4036-87fa-a666cac4e1b2"
    },
    {
      "examQuestionId": "3a7602d9-5090-49ab-93be-1f7881b4be86",
      "answerText": "You can use docker commit to save the changes.",
      "selectedOptionId": null
    }
  ]
}
```

> **Rules:**
> - For `MCQ`/`TrueFalse`: set `selectedOptionId` to the chosen option's ID, leave `answerText` as `""`
> - For `Essay`/`ShortAnswer`/`FillInTheBlank`: set `answerText`, leave `selectedOptionId` as `null`
> - Submit **all** answers in one call

**Response: `202 Accepted`**
```json
{
  "jobId": "1db82a45-fbc9-472d-a227-3c4336227b87",
  "message": "Exam submitted successfully. Grading has started."
}
```

---

### 7. Poll Grading Job Status
**`GET /api/v1/attempts/jobs/{jobId}`** | Role: `Student` or `Teacher`

Poll every 2–3 seconds after submission to track grading progress.

**Response: `200 OK`**
```json
{
  "id": "1db82a45-fbc9-472d-a227-3c4336227b87",
  "studentExamAttemptId": "7e0c24cf-c1ad-4d6a-adf6-ab2f2b0d53f9",
  "status": "Completed",
  "createdAt": "2026-08-19T14:00:00.000Z",
  "completedAt": "2026-08-19T14:00:15.000Z",
  "errorMessage": null
}
```

| `status` value       | Meaning                                                      |
|----------------------|--------------------------------------------------------------|
| `"Pending"`          | Waiting in queue                                             |
| `"Grading"`          | Agent 2 is actively grading (MCQ instant, Essays take ~10s) |
| `"Completed"`        | ✅ All answers graded, no issues                             |
| `"CompletedWithWarning"` | ⚠️ Some Essay answers have low AI confidence — needs teacher review |
| `"Failed"`           | Something went wrong, check `errorMessage`                   |

> Once `status` is `Completed` or `CompletedWithWarning`, call the results endpoint.

---

### 8. Get Results
**`GET /api/v1/attempts/{attemptId}/results`** | Role: `Student` or `Teacher`

Returns the full graded attempt with scores per answer.

**Response: `200 OK`**
```json
{
  "attemptId": "7e0c24cf-c1ad-4d6a-adf6-ab2f2b0d53f9",
  "examId": "1595afe8-ff4d-42b7-a365-2c956e31fff2",
  "isSubmitted": true,
  "submittedAt": "2026-08-19T14:00:01.000Z",
  "finalScore": 3.5,
  "needsTeacherReview": true,
  "answers": [
    {
      "answerId": "abc-123",
      "examQuestionId": "85ccf63c-...",
      "answerText": "",
      "selectedOptionId": "3742658d-...",
      "gradingResult": {
        "score": 1.0,
        "maxScore": 1.0,
        "confidenceScore": null,
        "isAiGraded": false,
        "needsTeacherReview": false,
        "rationale": null,
        "teacherOverrideScore": null
      }
    },
    {
      "answerId": "def-456",
      "examQuestionId": "3a7602d9-...",
      "answerText": "You can use docker commit to save the changes.",
      "selectedOptionId": null,
      "gradingResult": {
        "score": 0.4,
        "maxScore": 1.0,
        "confidenceScore": 0.72,
        "isAiGraded": true,
        "needsTeacherReview": true,
        "rationale": "The answer mentions docker commit but does not explain the container ID or image naming process as required by the rubric.",
        "teacherOverrideScore": null
      }
    }
  ]
}
```

> **`needsTeacherReview: true`** on a specific answer means AI confidence was below threshold (0.85). The teacher can override the score.
> 
> **`score`** already reflects `teacherOverrideScore` if present (via `GetFinalScore()`).

---

## 👨‍🏫 TEACHER — Reviewing & Overriding

### 9. Override Answer Score
**`PUT /api/v1/attempts/{attemptId}/answers/{answerId}/override`** | Role: `Teacher`

Overrides the AI score for a specific flagged answer. Automatically recalculates the total `FinalScore`.

**Request Body:**
```json
{
  "newScore": 0.8
}
```

**Response: `204 No Content`**

> The original AI `score`, `confidenceScore`, and `rationale` are **preserved**. Only `teacherOverrideScore` is updated. Call `/results` again to see the updated total.

---

## 📡 Real-Time Updates (SignalR) — Optional

Instead of polling, the frontend can connect to these SignalR hubs for live push notifications:

| Hub URL                       | Event                        | When it fires                        |
|-------------------------------|------------------------------|--------------------------------------|
| `/hubs/exam-generation`       | `ExamGenerationProgress`     | On each generation status change     |
| `/hubs/exam-grading`          | `ExamGradingProgress`        | On each grading status change        |

**SignalR connection example (JS):**
```javascript
const connection = new signalR.HubConnectionBuilder()
  .withUrl("/hubs/exam-grading", { accessTokenFactory: () => jwtToken })
  .build();

connection.on("ExamGradingProgress", (data) => {
  console.log(data.status, data.totalScore, data.needsReview);
});

await connection.start();
```

---

## ⚠️ Key Rules for Frontend Team

| Rule | Detail |
|------|--------|
| **Always use fresh idempotency keys** | Use a new `UUID` for each generation and submission. Reusing a key returns the old job. |
| **Never show `isCorrect` to students** | Filter it out when fetching exam details for the student view. |
| **Essays take longer to grade** | Objective questions grade instantly. LLM grading for Essay/ShortAnswer takes ~5–15 seconds. |
| **Poll jobs, not attempts** | Use the `GradingJobId` (from submit response) to poll status. Only call `/results` when status is `Completed`. |
| **`CompletedWithWarning` is still usable** | It means the exam is graded but some answers need teacher review. Show the student their score with a note. |
