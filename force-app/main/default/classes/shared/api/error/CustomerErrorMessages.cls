public class CustomerErrorMessages {

    private static final Map<String, String> ERRORS = new Map<String, String>{
        ErrorCodes.CONTACT_NOT_FOUND => Label.CONTACT_NOT_FOUND,
        ErrorCodes.INTERNAL_ERROR => Label.INTERNAL_ERROR,
        ErrorCodes.UUID_MISSING => Label.UUID_MISSING
    };

    public static String get(String code) {
        return ERRORS.get(code);
    }
}