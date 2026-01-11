public class ApiResponseFactory {

    public static void writeSuccess(Object data) {
        write(200, new ApiResponseDTO(data));
    }

    public static void writeBadRequest(String responseCode) {
        write(400, new ApiResponseDTO(
            new ApiErrorResponseDTO(responseCode, CustomerErrorMessages.get(responseCode))
        ));
    }

    public static void writeNotFound(String responseCode) {
        write(404, new ApiResponseDTO(
            new ApiErrorResponseDTO(responseCode, CustomerErrorMessages.get(responseCode))
        ));
    }

    public static void writeServerError(Exception ex) {
        write(500, new ApiResponseDTO(
            new ApiErrorResponseDTO(
                ErrorCodes.INTERNAL_ERROR,
                CustomerErrorMessages.get(ErrorCodes.INTERNAL_ERROR),
                new List<String>{ ex.getMessage() }
            )
        ));
    }

    private static void write(Integer statusCode, ApiResponseDTO response) {
        RestContext.response.statusCode = statusCode;
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody =
            Blob.valueOf(JSON.serialize(response));
    }
}