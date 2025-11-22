package util; // 또는 다른 적절한 패키지 이름

import com.google.gson.*;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {

    // LocalDateTime을 JSON으로 변환할 때 사용할 포맷을 지정합니다.
    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    @Override
    public JsonElement serialize(LocalDateTime src, Type typeOfSrc, JsonSerializationContext context) {
        // LocalDateTime 객체를 지정된 포맷의 문자열로 변환하여 JSON 기본 요소로 만듭니다.
        return new JsonPrimitive(formatter.format(src));
    }

    @Override
    public LocalDateTime deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
        // JSON 문자열을 다시 LocalDateTime 객체로 변환합니다.
        return LocalDateTime.parse(json.getAsString(), formatter);
    }
}