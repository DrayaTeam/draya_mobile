# Frontend Integration Guide
**Version: 1.0.0**  
**Date: August 2026**

This document outlines the recent changes made to the Draya Backend, focusing on the new **Teacher Override SignalR Notification**, updates to **Classroom DTOs**, and how to consume **Weakness Progression Tracking**.

---

## 1. Teacher Override Real-time Notification

When a teacher overrides an answer score in a student's attempt, the backend will now publish a SignalR notification directly to that student so the UI can update in real-time.

### Connection Details
- **Hub URL**: `/hubs/notifications`
- **Authentication**: Pass the student's JWT token in the connection setup (standard SignalR Bearer token). The backend will automatically map this to the student's User ID.

### Listening to Events
You need to listen for the `AnswerScoreOverridden` event on the Hub.

**Event Signature:**
```typescript
connection.on("AnswerScoreOverridden", (payload: AnswerScoreOverriddenPayload) => {
    console.log("Score overridden!", payload);
    // Update the UI...
});
```

**Payload Interface:**
```typescript
interface AnswerScoreOverriddenPayload {
    attemptId: string; // Guid
    answerId: string; // Guid
    newScore: number; // decimal (e.g., 8.5)
}
```

> [!TIP]
> Use this payload to find the specific answer in the local state of the Exam Attempt View and update the displayed score. If the exam attempt is currently open, a toast notification saying "Your teacher updated a score!" is recommended.

---

## 2. Classroom DTO Updates (Dashboard & Course View)

The backend now returns accurate counts for sections and lessons directly on the `ClassroomDto` instead of returning `0`.

**Affected Endpoints:**
- `GET /api/v1/classrooms`
- `GET /api/v1/classrooms/student`
- `GET /api/v1/classrooms/teacher`
- `GET /api/v1/classrooms/{id}`

**Changes to Interface:**
```diff
interface ClassroomDto {
    classroomId: string;
    teacherId: string;
    subjectName: string;
    name: string;
    enrollmentCode: string;
    isActive: boolean;
    studentCount: number;
    createdAt: string; // ISO 8601 Date
    classroomTypeName: string;
    gradeLevelName: string;
    startDate: string; // ISO 8601 Date
    endDate: string; // ISO 8601 Date
    price: number;
    imageUrl: string | null;
-   materialsCount: number; // Deprecated (Will mirror LessonsCount)
+   sectionsCount: number; // Number of distinct sections in the classroom
+   lessonsCount: number; // Total number of learning materials across all sections
    studentProgress: StudentProgressDto | null;
    teacherName: string | null;
    teacherAvatarUrl: string | null;
}
```

> [!IMPORTANT]
> The `materialsCount` field will currently mirror `lessonsCount` for backwards compatibility, but `lessonsCount` should be preferred going forward.

---

## 3. Weakness Tracking & Lazy Evaluation

When a student takes an exam, their weaknesses are tracked dynamically. The AI review feature is heavily optimized using lazy caching.

### Progression Tracking
To view the progression of a student's proficiency in a topic:
- Use `GET /api/v1/students/{studentId}/weaknesses/active` and `GET /api/v1/students/{studentId}/weaknesses/resolved`.
- Each `StudentWeaknessDto` now returns an array of `History` items (`StudentWeaknessHistoryDto`).
- Use this `History` array to draw the line chart of their proficiency progression (e.g. 40% -> 60% -> 90%) over time.

### Invalidated Caches (Lazy AI Reload)
If a teacher overrides a score (which you get via SignalR), or if the student completes a new attempt, their weakness proficiency changes.

- When proficiency changes, the backend marks `IsOutdated = true` on the weakness.
- **Action Required on Frontend**: The next time the student expands that weakness to view the AI explanation, make a call to `GET /api/v1/students/{studentId}/weaknesses/{topicId}/review`. 
- Because the cache is outdated, the backend will return `202 Accepted` while it lazily generates a brand-new explanation using the LLM based on their **new** proficiency.
- Subscribe to the `ReportsNotificationHub` (`/hubs/reports`) for the `WeaknessReviewGenerated` event to know when the new AI explanation is ready.
