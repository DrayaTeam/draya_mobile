# Project Agent Instructions

## Purpose

These instructions define the standard architecture and implementation
workflow for integrating any new API feature into this Flutter project.

Every API integration must follow the existing project architecture and
conventions. Do not introduce a different architecture for a new
feature.

------------------------------------------------------------------------

## 1. Mandatory Architecture

The project follows Clean Architecture with three layers:

``` text
lib/
└── features/
    └── <feature-area>/
        └── <feature>/
            ├── data/
            │   ├── models/
            │   ├── repos/
            │   └── source/
            │
            ├── domain/
            │   ├── entity/
            │   ├── repos/
            │   └── usecases/
            │
            └── presentation/
                ├── <screen_or_feature>/
                │   ├── cubit/
                │   ├── state/
                │   └── ...
                └── ...
```

The exact folder names and file naming conventions must first be
verified against the existing project.

### Feature ownership

Features must be placed under the correct feature area/role.

For example:

``` text
lib/features/teacher/classrooms/
```

because classrooms belong to the teacher feature.

Do not create:

``` text
lib/features/classrooms/
```

when the feature belongs to teacher.

Before implementing anything, inspect:

``` text
lib/features/
lib/features/auth/
lib/features/teacher/
lib/features/student/
```

and determine where the new feature belongs.

------------------------------------------------------------------------

## 2. Inspect Existing Code Before Implementing

Before creating files, inspect existing implementations, especially:

``` text
lib/features/auth/
lib/features/teacher/
lib/core/networking/
lib/core/di/
lib/core/
```

Look for existing examples of:

-   Retrofit API interfaces
-   Dio configuration
-   repository interfaces
-   repository implementations
-   data sources
-   Freezed models
-   json_serializable models
-   domain entities
-   use cases
-   Cubits
-   states
-   pagination
-   error handling
-   API response wrappers
-   dependency injection
-   UI integration
-   localization
-   loading/error/success states

The existing project implementation is the source of truth.

If the existing architecture differs from an example in these
instructions, follow the project's existing architecture.

Do not create duplicate infrastructure when an equivalent already
exists.

------------------------------------------------------------------------

## 3. API Integration Workflow

For every new API feature, follow this order:

1.  Understand the API contract.
2.  Inspect existing project conventions.
3.  Define request/response models.
4.  Implement the Retrofit remote data source.
5.  Define domain entities.
6.  Define the domain repository.
7.  Implement the data repository.
8.  Create use cases.
9.  Register dependencies in GetIt using the existing DI pattern.
10. Create Cubit and states.
11. Connect Cubit to the presentation/UI.
12. Implement loading, success, empty, and error UI states.
13. Generate Freezed/json_serializable code.
14. Run analyzer/tests/build checks.
15. Fix issues caused by the implementation.
16. Do not modify unrelated features.

------------------------------------------------------------------------

# 4. Data Layer

## 4.1 Models

Use **Freezed + json_serializable** for API models whenever the project
supports this pattern.

Typical model structure:

``` dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_model.freezed.dart';
part 'example_model.g.dart';

@freezed
class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required String id,
    required String name,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(Map<String, dynamic> json) =>
      _$ExampleModelFromJson(json);
}
```

Follow the existing project's conventions for:

-   nullable fields
-   `@JsonKey`
-   JSON field names
-   DateTime
-   enums
-   nested objects
-   lists
-   default values
-   custom converters
-   generated files

Do not manually write generated `.freezed.dart` or `.g.dart` files.

Use the project's existing build_runner command.

------------------------------------------------------------------------

## 4.2 Request Models

Request bodies should also use the project's established
Freezed/json_serializable pattern.

Example:

``` dart
@freezed
class CreateExampleRequest with _$CreateExampleRequest {
  const factory CreateExampleRequest({
    required String name,
  }) = _CreateExampleRequest;

  factory CreateExampleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateExampleRequestFromJson(json);
}
```

If the project separates domain request parameters from data request
models, preserve that separation.

Do not pass data-layer DTOs directly into the domain layer unless that
is already the project's established convention.

------------------------------------------------------------------------

# 5. Retrofit

Use **Retrofit** for all REST API integrations.

Do not make raw Dio calls from repositories when a Retrofit data source
is the established project pattern.

Inspect the existing Retrofit implementation before creating a new one.

Typical structure:

``` dart
@RestApi()
abstract class ExampleRemoteDataSource {
  factory ExampleRemoteDataSource(Dio dio, {String baseUrl}) =
      _ExampleRemoteDataSource;

  @POST('/examples')
  Future<ExampleModel> createExample(
    @Body() CreateExampleRequest request,
  );

  @GET('/examples')
  Future<List<ExampleModel>> getExamples();
}
```

The exact annotations, return types, headers, query parameters, path
parameters, and base URL handling must follow the existing project.

### Rules

-   Reuse the existing configured `Dio`.
-   Reuse existing interceptors.
-   Reuse existing authorization/token handling.
-   Reuse existing base URL configuration.
-   Do not create a second Dio instance.
-   Do not hard-code authentication tokens.
-   Do not create another networking abstraction if one already exists.

Use the exact API paths from the backend contract.

Never invent endpoint paths.

------------------------------------------------------------------------

# 6. Domain Layer

The domain layer must not depend on Retrofit, Dio, JSON serialization,
or data-layer models.

Structure:

``` text
domain/
├── entity/
├── repos/
└── usecases/
```

## 6.1 Entities

Create domain entities representing business data.

Example:

``` dart
class Example {
  final String id;
  final String name;

  const Example({
    required this.id,
    required this.name,
  });
}
```

Follow the project's existing entity conventions, including:

-   Freezed entities if already used
-   Equatable if already used
-   immutable classes
-   nullable/non-nullable rules

Do not put API-specific serialization logic in domain entities.

------------------------------------------------------------------------

## 6.2 Model to Entity Mapping

Every API response model must be converted to the corresponding domain
entity.

Follow the project's existing mapper convention.

Example:

``` dart
extension ExampleModelMapper on ExampleModel {
  Example toEntity() {
    return Example(
      id: id,
      name: name,
    );
  }
}
```

Data models must not leak into the presentation layer.

The UI should work with domain entities or presentation-specific view
models according to the existing architecture.

------------------------------------------------------------------------

# 7. Repository

## 7.1 Domain Repository

Create an abstract repository inside:

``` text
domain/repos/
```

Example:

``` dart
abstract class ExampleRepo {
  Future<Either<Failure, Example>> createExample(
    CreateExampleParams params,
  );

  Future<Either<Failure, List<Example>>> getExamples();
}
```

Use the project's existing `Either`, `Failure`, `Result`, or error
abstraction.

Do not introduce a second result/error system.

------------------------------------------------------------------------

## 7.2 Repository Implementation

Implement the repository inside:

``` text
data/repos/
```

Responsibilities:

-   call the Retrofit remote data source
-   convert models to entities
-   handle errors using the existing error handling mechanism
-   return the project's standard result type

The repository must not contain UI logic.

It must not contain Cubit/state logic.

------------------------------------------------------------------------

# 8. Use Cases

Create one use case for each business operation when that matches the
existing architecture.

Example:

``` dart
class GetExamplesUseCase {
  final ExampleRepo repository;

  GetExamplesUseCase(this.repository);

  Future<Either<Failure, List<Example>>> call() {
    return repository.getExamples();
  }
}
```

Use cases depend only on domain repositories.

They must not depend on:

-   Dio
-   Retrofit
-   data models
-   Cubit
-   Flutter widgets
-   BuildContext

Follow the project's existing use-case naming and constructor
conventions.

------------------------------------------------------------------------

# 9. Presentation Layer

Every API feature that requires UI integration must implement its
presentation layer.

Structure according to the existing project, for example:

``` text
presentation/
└── <feature_screen>/
    ├── cubit/
    │   ├── example_cubit.dart
    │   └── example_state.dart
    └── ...
```

If the project uses a different organization, follow the existing
convention.

Do not invent a new presentation architecture.

------------------------------------------------------------------------

# 10. Cubit

Use **Cubit** for state management when integrating API features.

Cubit must depend on use cases, not repositories or data sources.

Correct dependency direction:

``` text
UI
 ↓
Cubit
 ↓
UseCase
 ↓
Domain Repository
 ↓
Repository Implementation
 ↓
Retrofit Remote DataSource
 ↓
API
```

Never do:

``` text
UI → Dio
UI → Retrofit
Cubit → Dio
Cubit → RepositoryImplementation
Cubit → DataModel
```

------------------------------------------------------------------------

# 11. States

Use the project's existing Freezed state pattern if available.

For example:

``` dart
@freezed
class ExampleState with _$ExampleState {
  const factory ExampleState.initial() = _Initial;

  const factory ExampleState.loading() = _Loading;

  const factory ExampleState.success(
    List<Example> examples,
  ) = _Success;

  const factory ExampleState.error(
    String message,
  ) = _Error;
}
```

Use Freezed for states when that is consistent with the project.

States should cover the actual UI lifecycle.

At minimum, consider:

-   initial
-   loading
-   success
-   empty
-   error

Do not create unnecessary states.

If the existing project uses a different state pattern, follow it.

------------------------------------------------------------------------

# 12. Cubit Implementation

Cubit should call the appropriate use case and emit states.

Example:

``` dart
class ExampleCubit extends Cubit<ExampleState> {
  final GetExamplesUseCase getExamplesUseCase;

  ExampleCubit({
    required this.getExamplesUseCase,
  }) : super(const ExampleState.initial());

  Future<void> getExamples() async {
    emit(const ExampleState.loading());

    final result = await getExamplesUseCase();

    result.fold(
      (failure) {
        emit(
          ExampleState.error(
            failure.message,
          ),
        );
      },
      (examples) {
        if (examples.isEmpty) {
          emit(const ExampleState.empty());
        } else {
          emit(
            ExampleState.success(examples),
          );
        }
      },
    );
  }
}
```

Adapt this to the project's existing `Failure` and state conventions.

Do not expose exceptions directly to the UI if the project already
converts them into `Failure`.

------------------------------------------------------------------------

# 13. UI Integration

The API implementation is not complete until it is connected to the UI
when the task requires UI integration.

Use the project's existing Bloc/Cubit integration pattern.

Typical structure:

``` dart
BlocProvider(
  create: (_) => getIt<ExampleCubit>()..getExamples(),
  child: const ExampleView(),
)
```

Inside the UI:

``` dart
BlocBuilder<ExampleCubit, ExampleState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const LoadingWidget(),
      success: (items) => ExampleList(items: items),
      empty: () => const EmptyWidget(),
      error: (message) => ErrorWidget(message: message),
    );
  },
)
```

Follow the project's actual Freezed/BlocBuilder pattern.

Do not hard-code UI styling if reusable project widgets already exist.

Reuse:

-   existing loading widgets
-   existing error widgets
-   existing empty-state widgets
-   existing buttons
-   existing dialogs
-   existing localization
-   existing theme
-   existing spacing/constants

------------------------------------------------------------------------

# 14. User Actions

For API operations triggered by the user, connect UI actions to the
appropriate Cubit method.

Examples:

``` text
Create
Edit
Delete
Refresh
Retry
Activate/Deactivate
Search
Pagination
Load more
Regenerate code
Update pricing
```

The UI should never call the repository directly.

Correct:

``` text
Button
  ↓
Cubit
  ↓
UseCase
```

Incorrect:

``` text
Button
  ↓
Repository
```

------------------------------------------------------------------------

# 15. Loading and Error UX

Every API operation that affects the UI must have appropriate feedback.

Handle:

-   loading
-   success
-   empty response
-   validation errors
-   unauthorized responses
-   forbidden responses
-   not found
-   conflict
-   business-rule errors
-   server errors
-   network failures

Use the existing project's error-message/localization mechanism.

Do not hard-code backend error messages in widgets if the project
already has centralized error handling/localization.

------------------------------------------------------------------------

# 16. Pagination

Before implementing pagination, search the project for existing
pagination classes.

Search for:

``` text
PagedResult
Pagination
PaginationParams
PageResult
page
pageSize
skip
limit
loadMore
```

Reuse the existing pagination implementation.

Do not create another pagination system.

For paginated screens:

-   load the first page through Cubit
-   preserve existing items when loading more
-   prevent duplicate requests
-   handle the end of the list
-   expose loading-more state if the project uses one
-   handle refresh correctly

------------------------------------------------------------------------

# 17. Dependency Injection

Use the existing GetIt setup.

Before adding registrations, inspect:

``` text
lib/core/di/
```

and existing feature registrations.

Register, where applicable:

``` text
RemoteDataSource
Repository
UseCases
Cubit
```

Use the same lifetime/register method as the existing project.

For example, if the project uses:

``` dart
registerFactory(...)
registerLazySingleton(...)
```

follow the established convention.

Do not create another service locator.

------------------------------------------------------------------------

# 18. API Error Handling

Use the existing centralized networking/error handling.

Common backend errors may include:

``` text
400 Bad Request
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
422 Unprocessable Entity
429 Too Many Requests
500 Internal Server Error
```

Do not create duplicate exception/failure classes if the project already
handles these centrally.

If a feature has a special business error, map it using the existing
error architecture.

------------------------------------------------------------------------

# 19. Freezed and json_serializable

Freezed and json_serializable are required for this project.

When appropriate, use:

``` dart
part 'file.freezed.dart';
part 'file.g.dart';
```

For generated models:

``` dart
@freezed
class ExampleModel with _$ExampleModel {
  const factory ExampleModel({
    required String id,
  }) = _ExampleModel;

  factory ExampleModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ExampleModelFromJson(json);
}
```

For states:

``` dart
@freezed
class ExampleState with _$ExampleState {
  ...
}
```

Do not manually edit generated files.

Run:

``` bash
dart run build_runner build --delete-conflicting-outputs
```

If the project uses a different established command, use that command.

After generation, verify that:

``` text
*.freezed.dart
*.g.dart
```

are generated correctly.

------------------------------------------------------------------------

# 20. File Naming

Follow the existing project's naming convention.

Use clear names such as:

``` text
example_model.dart
create_example_request_model.dart
example_remote_data_source.dart
example_repo.dart
example_repo_impl.dart
example_entity.dart
create_example_use_case.dart
get_examples_use_case.dart
example_cubit.dart
example_state.dart
```

Do not use inconsistent names such as:

``` text
ExampleRepository.dart
exampleRepository.dart
ExampleCubit.dart
```

unless the existing project already uses that convention.

------------------------------------------------------------------------

# 21. No Unnecessary Duplication

Before creating a class, search the project.

Do not duplicate:

-   Failure
-   DioFactory
-   API error parser
-   pagination
-   common response wrappers
-   validators
-   date converters
-   enums
-   localization helpers
-   common widgets
-   DI setup
-   network interceptors
-   token management

Reuse existing code whenever possible.

------------------------------------------------------------------------

# 22. API Contract Accuracy

Never guess an API contract when it can be discovered.

Search the project for:

-   endpoint definitions
-   Swagger/OpenAPI
-   Retrofit interfaces
-   request DTOs
-   response DTOs
-   backend documentation
-   API examples
-   existing constants

Verify:

-   HTTP method
-   endpoint
-   path parameters
-   query parameters
-   request body
-   response body
-   status codes
-   nullable fields
-   pagination
-   enum values

If an important contract detail is genuinely unavailable, make the
smallest reasonable assumption and clearly report it after
implementation.

Do not silently invent API behavior.

------------------------------------------------------------------------

# 23. Feature Ownership Example

If a feature belongs to teacher:

``` text
lib/features/teacher/<feature>/
```

Example:

``` text
lib/features/teacher/classrooms/
```

If a feature belongs to student:

``` text
lib/features/student/<feature>/
```

If it is shared/global:

``` text
lib/features/<feature>/
```

Determine ownership from the existing application structure and
requirements.

------------------------------------------------------------------------

# 24. Complete API Feature Checklist

When asked to integrate an API feature, complete all applicable layers.

### Data

-   [ ] Retrofit remote data source
-   [ ] Freezed API models
-   [ ] json_serializable JSON conversion
-   [ ] Request models
-   [ ] Response models
-   [ ] Model-to-entity mapping
-   [ ] Repository implementation

### Domain

-   [ ] Entities
-   [ ] Repository interface
-   [ ] Request/parameter objects when required
-   [ ] Use cases

### Presentation

-   [ ] Cubit
-   [ ] Freezed state
-   [ ] Loading state
-   [ ] Success state
-   [ ] Empty state when applicable
-   [ ] Error state
-   [ ] Retry handling when applicable
-   [ ] UI integration
-   [ ] User action integration

### Infrastructure

-   [ ] GetIt dependency registration
-   [ ] Build runner generation
-   [ ] Analyzer check
-   [ ] Tests where applicable

------------------------------------------------------------------------

# 25. Verification

After implementation, run the project's standard checks.

At minimum:

``` bash
flutter analyze
```

and:

``` bash
dart run build_runner build --delete-conflicting-outputs
```

Verify:

-   no compilation errors
-   no missing generated files
-   Retrofit generated code compiles
-   Freezed generated code compiles
-   json_serializable generated code compiles
-   DI resolves all dependencies
-   Cubit resolves all use cases
-   UI receives the correct state
-   errors are displayed correctly
-   no unrelated feature was modified

------------------------------------------------------------------------

# 26. Final Implementation Report

After completing an API integration, provide a concise report
containing:

1.  Feature location.
2.  Files created.
3.  Files modified.
4.  APIs integrated.
5.  Models/entities/use cases created.
6.  Cubit and states created.
7.  UI screens/components integrated.
8.  DI registrations added.
9.  Generated files created.
11. Any API contract assumptions.
12. Any remaining issues.

Do not claim that an API integration is complete if the code does not
compile.

------------------------------------------------------------------------

# 27. Critical Rules

These rules are mandatory:

1.  Inspect the existing project before implementing.
2.  Preserve the existing architecture.
3.  Put the feature under the correct feature owner.
4.  Use Clean Architecture.
5.  Use Retrofit for API calls.
6.  Use Freezed and json_serializable for models/states where
    applicable.
7.  Use Cubit for presentation state management.
8.  Connect Cubit to the UI.
9.  Use existing Dio/networking infrastructure.
10. Use existing error handling.
11. Use existing dependency injection.
12. Reuse existing pagination.
13. Never let UI call the data layer directly.
14. Never let domain depend on data.
15. Never manually edit generated files.
16. Never create duplicate infrastructure.
17. Never guess API contracts when the information can be found.
18. Do not modify unrelated features.
19. Run code generation after changing Freezed/json_serializable files.
20. Run analyzer/build checks before declaring the task complete.

## UI Modernization Prompt

When asked to improve or polish an existing UI, make it modern, clean, polished, and production-ready while preserving the app's existing identity.

Use the existing app theme as the single source of truth:
- Reuse existing colors, typography, spacing, radii, shadows, icons, and shared components.
- Do not introduce arbitrary colors or a completely different visual style.
- Improve visual hierarchy, spacing, alignment, consistency, responsiveness, and readability.
- Prefer subtle, intentional styling over excessive decoration.
- Improve cards, buttons, inputs, app bars, lists, empty/error/loading states, and other visible components where appropriate.
- Reuse existing shared widgets, theme values, constants, and design-system components before creating new ones.
- Keep the UI accessible and responsive across screen sizes.
- Preserve existing functionality, navigation, state management, and API behavior.
- Do not modify data/domain layers unless required for the UI.
- Avoid unnecessary dependencies.

Before changing the UI, inspect the existing theme and reusable widgets. Then make the smallest set of changes needed to achieve a noticeably more modern and polished result.

Afterward, run `flutter analyze` and fix issues caused by the UI changes.

## Presentation Widget Organization

Keep page-specific UI components separated into a dedicated `widgets/` folder inside the page's presentation folder.

Example:

```text
presentation/
└── classrooms/
    ├── cubit/
    │   ├── classrooms_cubit.dart
    │   └── classrooms_state.dart
    ├── widgets/
    │   ├── classroom_card.dart
    │   ├── classroom_list.dart
    │   ├── classroom_header.dart
    │   └── ...
    └── classrooms_page.dart
```

Rules:

- Do not put large or meaningful UI components directly inside the page file.
- Extract meaningful UI sections into separate files under `widgets/`.
- Keep each widget focused on one responsibility.
- Keep the page mainly responsible for composition/layout and connecting Cubit/state to the UI.
- Reuse existing shared widgets from the project's shared/core widgets when applicable.
- If a widget is specific to one page, keep it inside that page's `widgets/` folder.
- If a widget is genuinely reusable across multiple features, place it in the project's shared widgets location following the existing architecture.
- Do not put business logic, API calls, repository logic, or use-case logic inside widgets.
- Widgets should receive required data and callbacks through parameters and remain as presentational as possible.
