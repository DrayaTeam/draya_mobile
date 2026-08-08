abstract class AppUseCase<Dynamic, Params> {
  Future<Dynamic> call({Params? params});
}
