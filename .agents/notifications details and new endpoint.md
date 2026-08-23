# Frontend Integration Guide

This document outlines the integration details for newly added/updated endpoints and all SignalR WebSockets used for real-time notifications across the Draya Platform.

---

## 1. Exam Attempts (Grades) Endpoint

A new endpoint allows Teachers to fetch all student attempts and final grades for a specific exam.

**Endpoint**: `GET /api/v1/exams/{examId}/attempts`

**Role**: `Teacher` (Must own the classroom where the exam is published)

**Query Parameters**:
- `page` (optional, default 1): The page number for pagination.
- `pageSize` (optional, default 10): Number of items per page.

**Response Structure (200 OK)**:
```json
{
  "items": [
    {
      "id": "e6a7c3b2-...", // StudentExamAttemptId
      "studentId": "01b21f85-...",
      "studentName": "Salma Samir-Adel",
      "finalScore": 85.5,
      "submittedAt": "2026-08-23T14:30:00Z"
    }
  ],
  "totalCount": 25
}
```

---

## 2. AI Question Refinement Endpoint

The endpoint for refining existing exam questions using AI has been hardened. The backend now robustly maps the AI's selected correct answer directly into a boolean flag for your convenience.

**Endpoint**: `POST /api/v1/exams/{examId}/questions/{questionId}/refine`

**Role**: `Teacher`

**Payload**:
```json
{
  "instruction": "Make this question harder by adding more distractors."
}
```

**Response Structure (200 OK)**:
You can now safely rely on the `isCorrect` boolean for each option. The backend automatically parses the AI's `CorrectAnswerIndex` and assigns `isCorrect: true` to the matching option.
```json
{
  "text": "What is the capital of France, keeping in mind historical shifts?",
  "type": 0, // e.g., Multiple Choice
  "difficulty": "Hard",
  "rubric": "Evaluates historical knowledge of European capitals.",
  "options": [
    {
      "text": "Lyon",
      "isCorrect": false
    },
    {
      "text": "Paris",
      "isCorrect": true
    }
  ]
}
```

---

## 3. SignalR WebSockets (Real-Time Notifications)

To provide a seamless, real-time experience, the frontend must connect to the following SignalR Hubs. Authentication is handled automatically via the JWT Bearer token passed during connection.

### A. Exam Generation Hub
**URL**: `/hubs/exam-generation`
**Role**: `Teacher`

Used to stream progress when a teacher generates a new exam using AI.

* **Connection**: Authenticated as the Teacher.
* **Events to Listen For**:
  - `ReceiveGenerationProgress`
    * **Payload**:
      ```typescript
      {
        generationId: string;
        status: "Pending" | "Retrieving" | "Generating" | "Validating" | "Completed" | "CompletedWithWarning" | "DataUnavailable" | "Failed";
        errorMessage: string | null;
        examId: string | null; // Populated when Status = Completed
      }
      ```

### B. Exam Grading Hub
**URL**: `/hubs/exam-grading`
**Role**: `Student` & `Teacher`

Streams progress when a student submits an exam and the AI grades open-ended questions.

* **Connection**: 
  - Clients must join a specific group to listen for updates. 
  - Send: `hubConnection.invoke("JoinGradingGroup", gradingJobId);`
* **Events to Listen For**:
  - `GradingProgressUpdated`
    * **Payload**:
      ```typescript
      {
        gradingJobId: string;
        status: "Pending" | "Grading" | "Completed" | "Failed";
        errorMessage: string | null;
        finalScore: number | null;
        needsTeacherReview: boolean;
      }
      ```

### C. Classroom Q&A Hub
**URL**: `/hubs/qa`
**Role**: `Teacher`, `Student`

Real-time updates for Classroom Questions and Answers.

* **Connection**: 
  - Clients must join a specific classroom group.
  - Send: `hubConnection.invoke("JoinClassroomGroup", classroomId);`
* **Events to Listen For**:
  - `QuestionCreated`
  - `QuestionReplied`
  - `QuestionVoteUpdated`
    * **Payload (Generic for all three)**:
      ```typescript
      {
        classroomId: string;
        questionId: string;
        // Contains updated counts or full question objects based on event
      }
      ```

### D. Reports Notifications Hub
**URL**: `/hubs/reports`
**Role**: `Teacher`

Notifies teachers of critical analytical insights regarding their students.

* **Connection**: Authenticated as the Teacher. The backend automatically routes notifications to the correct teacher based on their user ID.
* **Events to Listen For**:
  - `ReportGenerated`
    * **Triggered When**: An AI performance report has finished generating for a student.
    * **Payload**:
      ```typescript
      {
        reportId: string;
        studentId: string;
      }
      ```
  - `StudentAtRisk`
    * **Triggered When**: The system detects a student is severely falling behind or failing a topic.
    * **Payload**:
      ```typescript
      {
        studentId: string;
        topicName: string;
      }
      ```

### E. Materials Hub
**URL**: `/hubs/materials`
**Role**: `Teacher`

Notifies the client when a large uploaded document (PPTX, PDF) finishes AI processing/parsing in the background.

* **Connection**: Global broadcast to authenticated users.
* **Events to Listen For**:
  - `MaterialParsed`
    * **Payload**:
      ```typescript
      {
        materialId: string;
        versionId: string;
        status: "Success" | "Failed";
        message: string;
      }
      ```
