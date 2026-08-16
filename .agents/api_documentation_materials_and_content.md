# Draya API — Learning Materials & Content

Integration guide for Learning Materials & Content on the Draya platform, covering PDFs, Videos, DOCX, PPTX, and Images.

---

## 1. Authentication

All materials endpoints require:

```http
Authorization: Bearer <access_token>
```

---

## 2. Architecture — Versioning & Downloads

### Stable Material ID

The `materialId` never changes across file updates. Student bookmarks, lesson playlists, notes, and Q&A references remain intact.

### Zero Downtime

When a teacher uploads a new version:

- The previous version remains accessible.
- The new version is processed in the background.
- Processing transitions from `Pending` to `Parsed`.

### Audit & History

Teachers can view previous versions:

```http
GET /api/v1/materials/{materialId}/versions
```

### AI & Search Indexing

Vector embeddings and semantic-search chunks are tied to version hashes. Updating a document re-indexes only the modified content.

---

## 3. Supported Material Types

| `materialType` | Description |
|---|---|
| `Video` | `.mp4`, `.mov`, `.mkv`; processed in the background with Cloudinary |
| `PDF` | PDF document |
| `DOCX` | Word document |
| `PPTX` | PowerPoint presentation |
| `Image` | `.png`, `.jpg`, `.jpeg`, `.webp` |

## Processing Statuses

| `parseStatus` | Description |
|---|---|
| `Pending` | Video or heavy asset is uploading/processing |
| `Parsed` | Processing is complete and the material is ready |
| `Failed` | Processing failed; check `errorMessage` |

---

## 4. Downloading & Viewing Materials

For PDF, DOCX, PPTX, and Image materials, use:

```text
currentVersion.fileUrl
```

This is available when fetching:

```http
GET /api/v1/classrooms/{classroomId}/materials
```

or:

```http
GET /api/v1/students/materials
```

### Web

Use the file URL for browser download/viewing, for example:

```html
<a href="..." download>
```

### Mobile

The guide mentions:

- PDFKit — iOS
- PdfRenderer — Android
- `flutter_pdfview` — Flutter

---

## 5. Video Streaming

For videos, request a secure temporary streaming URL:

```http
GET /api/v1/materials/{materialId}/stream
```

Use the returned `streamUrl` with:

- HTML `<video>`
- AVPlayer — iOS
- ExoPlayer — Android

---

# 6. Upload Lesson Material — Teacher

```http
POST /api/v1/classrooms/{classroomId}/materials
```

**Authentication:** Teacher role

**Content-Type:**

```http
multipart/form-data
```

### Form Data

| Parameter | Type | Required | Description |
|---|---|---|---|
| `title` | string | Yes | Material title |
| `materialType` | string | Yes | `Video`, `PDF`, `DOCX`, `PPTX`, or `Image` |
| `file` | File / Binary | Yes | Actual file |

### Response — `202 Accepted`

```json
{
  "materialId": "e3a89e90-53cb-4f30-8be0-b99b5a266ce2",
  "title": "Physics Chapter 1 - Vectors",
  "materialType": "Video",
  "createdAt": "2026-08-16T04:00:00Z",
  "currentVersion": {
    "versionId": "f7685aa2-4c28-4444-9fa2-5883a992a001",
    "versionNumber": 1,
    "fileUrl": null,
    "parseStatus": "Pending",
    "uploadedAt": "2026-08-16T04:00:00Z",
    "errorMessage": null
  }
}
```

---

# 7. Get Materials by Classroom — Teacher & Student

```http
GET /api/v1/classrooms/{classroomId}/materials?page=1&pageSize=20
```

**Authentication:** Teacher or Student

### Query Parameters

| Parameter | Default |
|---|---:|
| `page` | `1` |
| `pageSize` | `20` |

### Response — `200 OK`

```json
{
  "items": [
    {
      "materialId": "e3a89e90-53cb-4f30-8be0-b99b5a266ce2",
      "title": "Physics Chapter 1 - Vectors",
      "materialType": "Video",
      "createdAt": "2026-08-16T04:00:00Z",
      "currentVersion": {
        "versionId": "f7685aa2-4c28-4444-9fa2-5883a992a001",
        "versionNumber": 1,
        "fileUrl": "Teacher_Ahmed/Physics_101/video_1",
        "parseStatus": "Parsed",
        "uploadedAt": "2026-08-16T04:00:00Z",
        "errorMessage": null
      }
    }
  ],
  "totalCount": 12,
  "pageNumber": 1,
  "pageSize": 20,
  "totalPages": 1,
  "hasNextPage": false,
  "hasPreviousPage": false
}
```

---

# 8. Get All Enrolled Materials — Student

```http
GET /api/v1/students/materials?page=1&pageSize=20
```

**Alias:**

```http
GET /api/v1/materials/enrolled?page=1&pageSize=20
```

**Authentication:** Student role

### Response — `200 OK`

```json
[
  {
    "materialId": "e3a89e90-53cb-4f30-8be0-b99b5a266ce2",
    "title": "Physics Chapter 1 - Vectors",
    "materialType": "Video",
    "createdAt": "2026-08-16T04:00:00Z",
    "currentVersion": {
      "versionId": "f7685aa2-4c28-4444-9fa2-5883a992a001",
      "versionNumber": 1,
      "fileUrl": "Teacher_Ahmed/Physics_101/video_1",
      "parseStatus": "Parsed",
      "uploadedAt": "2026-08-16T04:00:00Z",
      "errorMessage": null
    }
  },
  {
    "materialId": "1a2b3c4d-1111-2222-3333-444455556666",
    "title": "Vectors Worksheet & Homework",
    "materialType": "PDF",
    "createdAt": "2026-08-16T04:05:00Z",
    "currentVersion": {
      "versionId": "aa11bb22-3344-5566-7788-9900aabbccdd",
      "versionNumber": 1,
      "fileUrl": "Teacher_Ahmed/Physics_101/worksheet.pdf",
      "parseStatus": "Parsed",
      "uploadedAt": "2026-08-16T04:05:00Z",
      "errorMessage": null
    }
  }
]
```

---

# 9. Get Single Material Detail

```http
GET /api/v1/materials/{materialId}
```

**Authentication:** Teacher or Student

### Response — `200 OK`

```json
{
  "materialId": "e3a89e90-53cb-4f30-8be0-b99b5a266ce2",
  "title": "Physics Chapter 1 - Vectors",
  "materialType": "Video",
  "createdAt": "2026-08-16T04:00:00Z",
  "currentVersion": {
    "versionId": "f7685aa2-4c28-4444-9fa2-5883a992a001",
    "versionNumber": 1,
    "fileUrl": "Teacher_Ahmed/Physics_101/video_1",
    "parseStatus": "Parsed",
    "uploadedAt": "2026-08-16T04:00:00Z",
    "errorMessage": null
  }
}
```

---

# 10. Get Secure Video Streaming URL

```http
GET /api/v1/materials/{materialId}/stream
```

**Authentication:** Teacher or Student

### Response — `200 OK`

```json
{
  "provider": "Cloudinary",
  "videoId": "Teacher_Ahmed/Physics_101/video_1",
  "streamUrl": "https://res.cloudinary.com/q89yjswe/video/upload/v1723789000/Teacher_Ahmed/Physics_101/video_1.mp4",
  "expiresAt": "2026-08-16T06:00:00Z"
}
```

The returned `streamUrl` is temporary and expires at `expiresAt`.

---

# 11. Upload New Material Version — Teacher

```http
POST /api/v1/materials/{materialId}/versions
```

**Authentication:** Teacher role

**Content-Type:**

```http
multipart/form-data
```

### Form Data

| Parameter | Type | Required |
|---|---|---|
| `file` | File / Binary | Yes |

### Response — `202 Accepted`

```json
{
  "versionId": "9b12e6c5-84fa-4d56-8a03-2415ab545cc1",
  "versionNumber": 2,
  "fileUrl": null,
  "parseStatus": "Pending",
  "uploadedAt": "2026-08-16T04:15:00Z",
  "errorMessage": null
}
```

---

# 12. Get Material Version History — Teacher

```http
GET /api/v1/materials/{materialId}/versions
```

**Authentication:** Teacher role

### Response — `200 OK`

```json
[
  {
    "versionId": "9b12e6c5-84fa-4d56-8a03-2415ab545cc1",
    "versionNumber": 2,
    "fileUrl": "Teacher_Ahmed/Physics_101/video_v2",
    "parseStatus": "Parsed",
    "uploadedAt": "2026-08-16T04:15:00Z",
    "errorMessage": null
  },
  {
    "versionId": "f7685aa2-4c28-4444-9fa2-5883a992a001",
    "versionNumber": 1,
    "fileUrl": "Teacher_Ahmed/Physics_101/video_v1",
    "parseStatus": "Parsed",
    "uploadedAt": "2026-08-16T04:00:00Z",
    "errorMessage": null
  }
]
```

---

# 13. Check Version Processing Status — Teacher

```http
GET /api/v1/materials/{materialId}/versions/{versionId}/status
```

**Authentication:** Teacher role

### Response — `200 OK`

```json
{
  "versionId": "9b12e6c5-84fa-4d56-8a03-2415ab545cc1",
  "parseStatus": "Parsed",
  "errorMessage": null
}
```

Use `parseStatus` and `errorMessage` to determine whether background processing is complete or failed.

---

# 14. Delete Material — Teacher

Soft-deletes a material so it is no longer visible to students or teachers.

```http
DELETE /api/v1/materials/{materialId}
```

**Authentication:** Teacher role

### Response

```text
204 No Content
```

Successful deletion has an empty response body.

---

# 15. Endpoint Summary

| Feature | Method | Endpoint | Role |
|---|---|---|---|
| Upload material | `POST` | `/api/v1/classrooms/{classroomId}/materials` | Teacher |
| Get classroom materials | `GET` | `/api/v1/classrooms/{classroomId}/materials` | Teacher / Student |
| Get enrolled materials | `GET` | `/api/v1/students/materials` | Student |
| Get enrolled materials alias | `GET` | `/api/v1/materials/enrolled` | Student |
| Get material detail | `GET` | `/api/v1/materials/{materialId}` | Teacher / Student |
| Get video stream URL | `GET` | `/api/v1/materials/{materialId}/stream` | Teacher / Student |
| Upload new version | `POST` | `/api/v1/materials/{materialId}/versions` | Teacher |
| Get version history | `GET` | `/api/v1/materials/{materialId}/versions` | Teacher |
| Check version status | `GET` | `/api/v1/materials/{materialId}/versions/{versionId}/status` | Teacher |
| Delete material | `DELETE` | `/api/v1/materials/{materialId}` | Teacher |

---

# 16. Integration Flow

## Teacher — Upload Material

```text
Select File
    ↓
Choose title + materialType
    ↓
POST /api/v1/classrooms/{classroomId}/materials
    ↓
202 Accepted
    ↓
parseStatus = Pending
    ↓
Background Processing
    ↓
parseStatus = Parsed
    ↓
Material Ready
```

## Teacher — Update Material

```text
Existing Material
    ↓
Select Updated File
    ↓
POST /api/v1/materials/{materialId}/versions
    ↓
202 Accepted
    ↓
New Version = Pending
    ↓
Background Processing
    ↓
New Version = Parsed
```

## Student — Open Material

```text
Get Materials
    ↓
Check materialType
    ↓
    ├── PDF / DOCX / PPTX / Image
    │       ↓
    │   currentVersion.fileUrl
    │       ↓
    │   Open / Download
    │
    └── Video
            ↓
        GET /stream
            ↓
        streamUrl
            ↓
        Video Player
```

---

# 17. Agent Implementation Rules

When implementing these APIs:

1. Always send the JWT Bearer token.
2. Use `materialId` as the stable identifier.
3. Treat versions as file revisions under the same material.
4. Do not assume an upload is immediately ready after `202 Accepted`.
5. Handle `Pending`, `Parsed`, and `Failed`.
6. For documents/images, use `currentVersion.fileUrl`.
7. For videos, call `/stream` and use the returned temporary `streamUrl`.
8. Do not treat the temporary video URL as permanent.
9. Teachers can upload new versions without changing `materialId`.
10. Teachers can view version history.
11. Teachers can check background processing status.
12. Material deletion is a soft delete and returns `204 No Content`.
13. Respect endpoint role requirements.
14. Use `page` and `pageSize` for paginated material lists.
15. Keep the API/data models aligned with the documented response structures.
