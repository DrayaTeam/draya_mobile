# Draya API - Frontend Integration Guide

> Frontend integration reference for the AI-powered Revision System, Practice Exams, Performance Dashboards, and Notifications.
>
> Source: `frontend-integration-guide.pdf`

## Table of Contents

1. [Student Experience Flow](#1-student-experience-flow)
   - [A. Student Dashboard](#a-student-dashboard)
   - [B. Latest Performance Report](#b-latest-performance-report)
   - [C. AI Interactive Revision](#c-ai-interactive-revision)
   - [D. Generate Practice Exam](#d-generate-practice-exam)
2. [Teacher Experience Flow](#2-teacher-experience-flow)
   - [A. Teacher Dashboard](#a-teacher-dashboard)
   - [B. Teacher Exams Dashboard](#b-teacher-exams-dashboard)
   - [C. Approve Performance Report](#c-approve-performance-report)
3. [Real-Time Notifications (SignalR)](#3-real-time-notifications-signalr)
   - [A. Exam Generation Hub](#a-exam-generation-hub)
   - [B. Reports Notification Hub](#b-reports-notification-hub)
4. [End-to-End Walkthrough](#4-end-to-end-walkthrough)

---

# 1. Student Experience Flow

## A. Student Dashboard

The Student Dashboard populates the main screen when a student logs in.

### Endpoint

```http
GET /api/v1/dashboard/student
```

### Authorization

```text
Bearer Token (Student)
```

### Expected Response Schema

```json
{
  "overallAverage": 82.3,
  "completedLessonsCount": 37,
  "subscribedPackagesCount": 3,
  "urgentAlerts": [
    "Urgent review needed for Docker Storage (Backend)."
  ],
  "dailyLessons": [
    {
      "materialId": "uuid",
      "title": "Introduction to Docker",
      "completedLectures": 12,
      "totalLectures": 18
    }
  ],
  "upcomingExams": [
    {
      "examId": "uuid",
      "title": "Final Exam",
      "startDate": "2026-08-25T00:00:00Z",
      "endDate": "2026-08-26T00:00:00Z"
    }
  ],
  "pointsNeedingFocus": [
    {
      "topicName": "Docker Storage",
      "proficiencyPercent": 42.0
    }
  ],
  "lastActivityDate": "2026-08-21T00:00:00Z",
  "currentStreak": 5
}
```

## B. Latest Performance Report

Use this endpoint to fetch the student's latest competencies and weaknesses.

### Endpoint

```http
GET /api/v1/students/{studentId}/performance-reports/latest
```

### Authorization

```text
Bearer Token (Student or Teacher)
```

### Example Response

```json
{
  "id": "3cdd37b7-3aca-4d89-bb20-63c5986dd64c",
  "generatedAt": "2026-08-21T03:31:20.303Z",
  "summaryText": "Student has completed 3 exams with an overall average of 2.9%.",
  "weakTopics": [
    {
      "topicName": "storage in docker",
      "proficiencyPercent": 71.66,
      "recommendation": "Keep practicing this topic to reach full proficiency."
    }
  ],
  "subjectProficiencies": [
    {
      "subjectName": "english",
      "proficiencyPercent": 71.66
    }
  ]
}
```

> **Implementation tip:** Use the `topicName` from the `weakTopics` array to construct the URL for the AI Revision endpoint. URL-encode the topic name if it contains spaces, for example `storage%20in%20docker`.

## C. AI Interactive Revision

When the student clicks **Review** on a weak topic, call this endpoint.

The backend uses RAG to pull the exact classroom PDF/PPTX chunks and asks the LLM to explain the concept.

### Endpoint

```http
GET /api/v1/students/{studentId}/weak-topics/{topicName}/revision
```

### Authorization

```text
Bearer Token (Student)
```

### Example Response

```json
{
  "recommendation": "Keep practicing this topic to reach full proficiency.",
  "aiExplanation": "**Storage in Docker – explained with the course material only**

---

### 1. What Docker stores on the host
- **Docker host** contains three core pieces...

### 2. Images
- An **image** is a *template*..."
}
```

### Frontend Rendering

The `aiExplanation` field is returned as clean Markdown.

The frontend should use a Markdown parser, such as `react-markdown`, to render the explanation for the student.

## D. Generate Practice Exam

After the student reads the revision, they can generate an AI-crafted Practice Exam tailored strictly to that topic.

### Endpoint

```http
POST /api/v1/students/{studentId}/weak-topics/{topicName}/practice-exam
```

### Authorization

```text
Bearer Token (Student)
```

### Request Body

```json
{}
```

The request body is an empty JSON object.

### Example Response

```json
{
  "generationId": "143fb517-a5c6-4f98-bb77-4ed721739e00",
  "message": "Practice exam generation has started in the background. Connect to the SignalR hub '/hubs/exam-generation' to receive progress updates."
}
```

> **Important:** This endpoint returns `202 Accepted` because generating an exam takes time. Listen to the SignalR hub to determine when the exam is ready.

---

# 2. Teacher Experience Flow

## A. Teacher Dashboard

The Teacher Dashboard populates the main screen when a teacher logs in.

### Endpoint

```http
GET /api/v1/dashboard/teacher
```

### Authorization

```text
Bearer Token (Teacher)
```

### Expected Response Schema

```json
{
  "examsAwaitingReview": 3,
  "classAverage": 78.5,
  "activeStudents": 24,
  "reportsReadyForReview": 2,
  "newMessagesCount": 7,
  "weeklySubmissionsActivity": [
    {
      "dayOfWeek": "أحد",
      "submissionsCount": 12,
      "averageScore": 75.0
    },
    {
      "dayOfWeek": "إثنين",
      "submissionsCount": 8,
      "averageScore": 82.5
    }
  ],
  "needsAttentionList": [
    {
      "studentId": "uuid",
      "studentName": "John Doe",
      "overallAverage": 45.0
    }
  ],
  "recentSubmissions": [
    {
      "examAttemptId": "uuid",
      "studentId": "uuid",
      "studentName": "Jane Smith",
      "examTitle": "Midterm Exam",
      "submittedAt": "2026-08-21T10:00:00Z",
      "score": 85.0
    }
  ]
}
```

## B. Teacher Exams Dashboard

Teachers have a dashboard where they can see all official exams created for their classroom.

### Endpoint

```http
GET /api/v1/exams?classroomId={classroomId}
```

### Authorization

```text
Bearer Token (Teacher)
```

> **Practice Exam Isolation:** The API is specifically designed to filter out AI-generated practice exams created by students. This endpoint returns only official teacher-created exams for the Teacher Dashboard.

## C. Approve Performance Report

Performance Reports require a Teacher's approval before the system emails the summary to the student's parents.

Once the teacher reviews the report from their dashboard, they click **Approve**, which triggers this endpoint.

### Endpoint

```http
POST /api/v1/reports/{reportId}/approve
```

### Authorization

```text
Bearer Token (Teacher)
```

### Request Body

```json
{}
```

The request body is an empty JSON object.

### Expected Response

```json
{
  "message": "Report approved and email sent to parent."
}
```

> **Backend behavior:** Triggering the approve endpoint automatically dispatches the `ReportApprovedEvent` on the backend. The backend formats an HTML email using `IEmailService` and sends the AI-generated `SummaryText` to the `ParentGuardianEmail` associated with the student.

---

# 3. Real-Time Notifications (SignalR)

To provide a seamless, non-blocking user experience, the backend pushes real-time events to the frontend using SignalR hubs.

## A. Exam Generation Hub

Used for tracking the progress of both Teacher-created AI Exams and Student Practice Mini-Exams.

### Hub URL

```text
/hubs/exam-generation
```

### Event

```text
ReceiveGenerationProgress
```

### Payload

```json
{
  "GenerationId": "uuid",
  "Status": "Completed",
  "ErrorMessage": null,
  "ExamId": "uuid"
}
```

### Status Values

```text
Pending
Generating
Completed
Failed
```

### Frontend Behavior

When:

```text
Status == "Completed"
```

extract the `ExamId` and immediately route the user to:

```text
/exams/{ExamId}/take
```

or the equivalent route in the frontend.

The `ExamId` is used to open the actual generated practice exam.

## B. Reports Notification Hub

Used for notifying teachers when new performance reports are generated or when a student is falling behind.

### Hub URL

```text
/hubs/reports-notification
```

### Events

#### ReportGenerated

Payload:

```json
{
  "ReportId": "uuid",
  "StudentId": "uuid"
}
```

Frontend action:

```text
Show a toast notification to the teacher:
"A new performance report is available for Student X."
```

#### StudentAtRisk

Payload:

```json
{
  "StudentId": "uuid",
  "TopicName": "string"
}
```

Frontend action:

```text
Show a high-priority alert to the teacher:
"Student X is struggling with {TopicName}."
```

---

# 4. End-to-End Walkthrough

The complete flow from a student taking a normal exam to generating a practice exam is:

## Step 1 — Start Exam Attempt

```http
POST /api/v1/attempts/start
```

Request body:

```json
{
  "examId": "..."
}
```

## Step 2 — Submit Attempt

```http
POST /api/v1/attempts/{attemptId}/submit
```

Request body:

```json
{
  "answers": []
}
```

In the documented scenario, the student intentionally gets answers wrong for a specific topic such as **Docker Storage**.

## Step 3 — Wait for AI Grading

Either poll:

```http
GET /api/v1/attempts/jobs/{gradingJobId}
```

or listen to SignalR until grading completes.

## Step 4 — View Results

```http
GET /api/v1/attempts/{attemptId}/results
```

The results contain the final score and AI feedback on individual questions.

## Step 5 — Performance Report Generation

The backend automatically generates a Performance Report based on the graded attempt.

## Step 6 — Fetch Performance Report

```http
GET /api/v1/students/{studentId}/performance-reports/latest
```

The frontend displays the dashboard and highlights **Docker Storage** as a weak topic.

## Step 7 — Request AI Revision

```http
GET /api/v1/students/{studentId}/weak-topics/Docker%20Storage/revision
```

The student reads the custom Markdown AI explanation.

## Step 8 — Generate Practice Exam

```http
POST /api/v1/students/{studentId}/weak-topics/Docker%20Storage/practice-exam
```

The endpoint returns a `GenerationId`.

## Step 9 — Wait for Practice Exam

Listen to:

```text
/hubs/exam-generation
```

for the `ReceiveGenerationProgress` event.

## Step 10 — Take Practice Exam

When:

```text
Status == "Completed"
```

use the `ExamId` from the SignalR payload and redirect the student to the exam-taking screen.

Example route:

```text
/exams/{ExamId}/take
```

This allows the student to take their custom AI-generated practice exam.

---

# Frontend Integration Checklist

## Student

- [ ] Integrate Student Dashboard endpoint.
- [ ] Display overall average, completed lessons, subscribed packages, alerts, daily lessons, upcoming exams, focus points, last activity, and streak.
- [ ] Integrate Latest Performance Report.
- [ ] Display weak topics and subject proficiencies.
- [ ] URL-encode `topicName` before using it in the AI Revision endpoint.
- [ ] Integrate AI Interactive Revision.
- [ ] Render `aiExplanation` as Markdown.
- [ ] Integrate Practice Exam generation.
- [ ] Handle the `202 Accepted` response.
- [ ] Connect to `/hubs/exam-generation`.
- [ ] Listen for `ReceiveGenerationProgress`.
- [ ] Handle `Pending`, `Generating`, `Completed`, and `Failed`.
- [ ] On `Completed`, extract `ExamId`.
- [ ] Navigate to `/exams/{ExamId}/take`.

## Teacher

- [ ] Integrate Teacher Dashboard endpoint.
- [ ] Display exams awaiting review.
- [ ] Display class average.
- [ ] Display active students.
- [ ] Display reports ready for review.
- [ ] Display new messages count.
- [ ] Display weekly submission activity.
- [ ] Display students needing attention.
- [ ] Display recent submissions.
- [ ] Integrate Teacher Exams Dashboard.
- [ ] Pass `classroomId` as a query parameter.
- [ ] Remember that the endpoint returns only official teacher-created exams.
- [ ] Integrate Approve Performance Report.
- [ ] Connect to `/hubs/reports-notification`.
- [ ] Handle `ReportGenerated`.
- [ ] Handle `StudentAtRisk`.
- [ ] Show toast/alert notifications according to the documented actions.

## End-to-End Exam Flow

- [ ] Start an exam attempt.
- [ ] Submit answers.
- [ ] Wait for AI grading.
- [ ] Fetch attempt results.
- [ ] Wait for automatic Performance Report generation.
- [ ] Fetch the latest Performance Report.
- [ ] Identify weak topics.
- [ ] Request AI Revision for the selected weak topic.
- [ ] Generate a topic-specific Practice Exam.
- [ ] Wait for SignalR generation progress.
- [ ] Extract the generated `ExamId`.
- [ ] Navigate the student to the generated exam.
