# Classroom Q&A Channel — Frontend & Mobile Integration Guide

دليل تفصيلي لمهندسي **Frontend (Web)** و**Mobile (Android/iOS)** لربط ميزة **Classroom Q&A Channel**.

---

## 1. Endpoints Overview (REST API)

### Base URL

جميع الـ Q&A endpoints تندرج تحت الـ route الأساسي التالي، وهو خاص بـ Classroom معين:

```text
/api/v1/classrooms/{classroomId}/questions
```

### Authentication

جميع هذه الـ endpoints محمية وتحتاج إلى إرسال الـ JWT Token في:

```http
Authorization: Bearer <token>
```

---

### A. جلب الأسئلة — Pagination, Sorting, Filtering

```http
GET /api/v1/classrooms/{classroomId}/questions
```

هذا الـ endpoint يجلب قائمة الأسئلة الخاصة بالـ Classroom بشكل **Paginated** وبناءً على اختيارات الـ filtering والـ sorting.

#### Query Parameters — Optional

| Parameter | Description | Default / Values |
|---|---|---|
| `page` | رقم الصفحة | `1` |
| `pageSize` | عدد العناصر في الصفحة | `20` |
| `sortBy` | طريقة الترتيب | `recent`, `mostvoted`, `mostdiscussed`, `trending` |
| `filterBy` | الفلترة | `all`, `unanswered`, `answered`, `myposts` |

#### `sortBy` values

- `recent` — الأحدث **(Default)**
- `mostvoted` — الأعلى تصويتًا
- `mostdiscussed` — الأكثر تفاعلًا، بناءً على عدد الردود
- `trending` — الشائع، بناءً على معادلة مدمجة بين التصويتات والردود

#### `filterBy` values

- `all` — كل الأسئلة **(Default)**
- `unanswered` — الأسئلة التي ليس لها إجابة رسمية من المدرس
- `answered` — الأسئلة التي عليها إجابة رسمية من المدرس
- `myposts` — الأسئلة التي كتبها المستخدم الحالي فقط

#### Response Structure — `200 OK`

```json
{
  "items": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "classroomId": "...",
      "authorId": "...",
      "content": "نص السؤال هنا",
      "createdAt": "2026-08-14T19:40:00Z",
      "voteCount": 5,
      "replyCount": 2,
      "hasTeacherAnswer": false,
      "hasVoted": true,
      "isAuthor": false
    }
  ],
  "pageNumber": 1,
  "pageSize": 20,
  "totalCount": 50,
  "totalPages": 3,
  "hasPreviousPage": false,
  "hasNextPage": true
}
```

---

### B. إضافة سؤال جديد

```http
POST /api/v1/classrooms/{classroomId}/questions
```

#### Request Body

```json
{
  "content": "نص السؤال هنا"
}
```

#### Response — `201 Created`

يرجع نفس الـ **QuestionDto** الخاص بالسؤال الذي ظهر في قائمة الأسئلة.

---

### C. عرض تفاصيل سؤال مع الردود

```http
GET /api/v1/classrooms/{classroomId}/questions/{questionId}
```

يُستخدم عندما يضغط المستخدم على سؤال لعرض تفاصيله بالكامل والردود الموجودة تحته.

#### Response — `200 OK`

```json
{
  "question": {
    "id": "...",
    "classroomId": "...",
    "authorId": "...",
    "content": "نص السؤال هنا",
    "createdAt": "2026-08-14T19:40:00Z",
    "voteCount": 5,
    "replyCount": 2,
    "hasTeacherAnswer": false,
    "hasVoted": true,
    "isAuthor": false
  },
  "replies": [
    {
      "id": "...",
      "questionId": "...",
      "authorId": "...",
      "content": "رد الطالب أو المدرس",
      "createdAt": "2026-08-14T19:45:00Z",
      "isTeacherAnswer": true,
      "isAuthor": false
    }
  ]
}
```

> **UI:** إذا كانت `isTeacherAnswer == true`، يجب أن يميز الـ UI هذا الرد، مثلًا باستخدام لون مختلف أو Badge باسم **Official Answer**.

---

### D. إضافة رد على سؤال

```http
POST /api/v1/classrooms/{classroomId}/questions/{questionId}/replies
```

#### Request Body

```json
{
  "content": "نص الرد هنا"
}
```

#### Important UI / Backend Behavior

إذا كان المستخدم الذي أضاف الرد هو **مدرس الـ Classroom**، فالـ backend سيعتبر الرد تلقائيًا هو **Official Teacher Answer**:

- `isTeacherAnswer = true`
- يتم اعتبار السؤال **Answered**
- المدرس لا يستطيع إضافة أكثر من **Official Answer** واحد على نفس السؤال.

---

### E. عمل Upvote على سؤال

```http
POST /api/v1/classrooms/{classroomId}/questions/{questionId}/vote
```

#### Request Body

لا يوجد body.

#### Response

```text
200 OK
```

#### UI Behavior

يفضل تنفيذ **Optimistic UI**:

- زيادة `voteCount` فورًا بمقدار `+1`.
- تغيير شكل زر الـ Upvote فورًا.
- إذا حدث Error، يتم إرجاع الحالة السابقة.

---

### F. إلغاء الـ Upvote

```http
DELETE /api/v1/classrooms/{classroomId}/questions/{questionId}/vote
```

#### Request Body

لا يوجد body.

#### Response

```text
200 OK
```

#### UI Behavior

- تقليل `voteCount` بمقدار `-1`.
- تحديث شكل زر الـ Upvote.

---

# 2. SignalR — Real-time Events

عشان قناة الـ Q&A تبان حية والأسئلة والردود تظهر للطلبة الآخرين بدون عمل Refresh، يجب الاتصال بالـ **SignalR Hub** الجديد.

## A. Connection

### Hub URL

```text
wss://{domain}/hubs/qa
```

أو `https` حسب البروتوكول المستخدم في الـ connection.

### Authentication

يجب إرسال الـ **Access Token** أثناء إنشاء الـ connection.

---

## B. Join Classroom Group

أول ما الـ connection يفتح، يجب إخبار الـ backend أن المستخدم دخل صفحة الـ Classroom حتى يتم إرسال أحداث هذا الـ Classroom فقط.

### Join

```dart
await connection.invoke("JoinClassroom", classroomId);
```

### Leave

عند خروج المستخدم من صفحة الـ Classroom، يفضل تنفيذ:

```dart
await connection.invoke("LeaveClassroom", classroomId);
```

---

## C. Listening to Events

الـ backend يرسل 3 أحداث رئيسية. الـ UI يجب أن يستمع إليها ويحدث البيانات بناءً عليها.

---

### 1. `QuestionCreated`

يتم إرساله عندما يقوم أي مستخدم بإنشاء سؤال جديد في الـ Classroom.

#### Payload

```json
{
  "classroomId": "...",
  "questionId": "...",
  "authorId": "...",
  "content": "...",
  "createdAt": "..."
}
```

#### UI Actions

إذا كان المستخدم على فلتر **Recent**:

- أضف السؤال الجديد في أول القائمة.

إذا كان الـ filter مختلفًا:

- يمكن عرض Snack Bar أو زر صغير برسالة:
  `New question posted. Click to refresh`

---

### 2. `QuestionReplied`

يتم إرساله عندما يقوم أي مستخدم بالرد على سؤال.

#### Payload

```json
{
  "classroomId": "...",
  "questionId": "...",
  "replyId": "...",
  "authorId": "...",
  "content": "...",
  "createdAt": "...",
  "isTeacherAnswer": true
}
```

#### UI Actions

إذا كان المستخدم فاتح صفحة **Question Details** الخاصة بالسؤال الذي وصل له الرد:

- أضف الرد مباشرة إلى قائمة الردود.

في قائمة الأسئلة:

- زِد `replyCount` للسؤال بمقدار `1`.

إذا كانت:

```text
isTeacherAnswer == true
```

فاجعل:

```text
hasTeacherAnswer = true
```

في الـ UI.

---

### 3. `QuestionVoteUpdated`

يتم إرساله عندما يتغير عدد التصويتات على سؤال، سواء بسبب عمل Upvote أو إلغائه.

#### Payload

```json
{
  "classroomId": "...",
  "questionId": "...",
  "voteCount": 6
}
```

#### UI Actions

حدّث `voteCount` للسؤال بالقيمة الجديدة القادمة من الـ event.

### Important UI Note

إذا كان الـ user يستخدم sorting من نوع **Most Voted**، فإن تغيير `voteCount` قد يغيّر ترتيب الأسئلة أمام المستخدم بشكل مفاجئ.

الأفضل:

- تحديث رقم `voteCount` فقط دون إعادة ترتيب القائمة، حتى لا يتلخبط المستخدم.
- أو تطبيق **Animation** خفيف عند الحاجة.

---

# 3. Frontend / Mobile Implementation Summary

## REST APIs

Implement the following operations:

| Operation | Method | Endpoint |
|---|---|---|
| Get questions | `GET` | `/api/v1/classrooms/{classroomId}/questions` |
| Create question | `POST` | `/api/v1/classrooms/{classroomId}/questions` |
| Get question details | `GET` | `/api/v1/classrooms/{classroomId}/questions/{questionId}` |
| Create reply | `POST` | `/api/v1/classrooms/{classroomId}/questions/{questionId}/replies` |
| Upvote question | `POST` | `/api/v1/classrooms/{classroomId}/questions/{questionId}/vote` |
| Remove upvote | `DELETE` | `/api/v1/classrooms/{classroomId}/questions/{questionId}/vote` |

## SignalR

Implement:

```text
Connect to /hubs/qa
        ↓
Authenticate with Access Token
        ↓
JoinClassroom(classroomId)
        ↓
Listen:
  ├── QuestionCreated
  ├── QuestionReplied
  └── QuestionVoteUpdated
        ↓
LeaveClassroom(classroomId)
```

## Key UI Rules

1. Use optimistic UI for question upvotes.
2. Highlight official teacher answers using `isTeacherAnswer`.
3. Use `hasTeacherAnswer` to show the answered state of a question.
4. Use `isAuthor` to identify the current user's own questions/replies.
5. Update `replyCount` when `QuestionReplied` is received.
6. Update `voteCount` when `QuestionVoteUpdated` is received.
7. Avoid unexpectedly reordering the list when vote counts change under **Most Voted** sorting.
8. For **Recent** sorting, add newly created questions to the top of the list.
9. When a new question arrives under another filter, consider showing a refresh Snack Bar instead of inserting it immediately.
10. Leave the SignalR Classroom group when the user exits the Classroom page.
