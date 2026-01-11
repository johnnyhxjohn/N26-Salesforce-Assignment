global class ApiErrorResponseDTO {
    global String errorCode;
    global String message;
    global List<String> details;

    global ApiErrorResponseDTO(String errorCode, String message) {
        this.errorCode = errorCode;
        this.message = message;
        this.details = new List<String>();
    }

    global ApiErrorResponseDTO(String errorCode, String message, List<String> details) {
        this.errorCode = errorCode;
        this.message = message;
        this.details = details != null ? details : new List<String>();
    }
}