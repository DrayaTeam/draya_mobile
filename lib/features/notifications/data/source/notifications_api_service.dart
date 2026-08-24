import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/notifications/data/models/notifications_page_model.dart";
import "package:retrofit/retrofit.dart";

part "notifications_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NotificationsApiService {
  factory NotificationsApiService(Dio dio) = _NotificationsApiService;

  @GET("/notifications")
  Future<NotificationsPageModel> getNotifications({
    @Query("page") int page = 1,
    @Query("pageSize") int pageSize = 20,
    @Query("unreadOnly") bool unreadOnly = false,
  });

  @PUT("/notifications/{id}/read")
  Future<void> markAsRead(@Path("id") String id);

  @PUT("/notifications/read-all")
  Future<void> markAllAsRead();

  @DELETE("/notifications/{id}")
  Future<void> deleteNotification(@Path("id") String id);

  @DELETE("/notifications")
  Future<void> clearAll();
}
