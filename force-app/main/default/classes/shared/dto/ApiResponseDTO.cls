global with sharing class ApiResponseDTO {
    global Object data;
    global ApiErrorResponseDTO error;

    global ApiResponseDTO(Object data) {
        this.data = data;
        this.error = null;
    }

    global ApiResponseDTO(ApiErrorResponseDTO error) {
        this.data = null;
        this.error = error;
    }
}