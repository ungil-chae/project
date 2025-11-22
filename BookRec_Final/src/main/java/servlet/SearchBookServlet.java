package servlet; // 본인의 서블릿 패키지명으로 수정하세요.

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets; // [개선] 명시적인 Charset 사용
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig; // [수정] ServletConfig 임포트
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SearchBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // [수정 1] API 키를 멤버 변수로 선언
    private String clientId;
    private String clientSecret;

    /**
     * [수정 1] 서블릿이 처음 초기화될 때 web.xml에 설정된 컨텍스트 파라미터 값을 읽어와 멤버 변수에 저장합니다.
     * 이 방식은 서블릿이 실행되는 동안 키 값을 한 번만 읽어오므로 효율적입니다.
     */
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        clientId = config.getServletContext().getInitParameter("J_KN25avSMSi7_dSKzMc");
        clientSecret = config.getServletContext().getInitParameter("EL3xr_EnHO");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 클라이언트에게 반환할 컨텐츠 타입과 인코딩 설정
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String keyword = request.getParameter("query");

            if (keyword == null || keyword.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"검색어를 입력해주세요.\"}");
                return;
            }

            String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8.name());
            String apiURL = "https://openapi.naver.com/v1/search/book.json?query=" + encodedKeyword + "&display=20";

            Map<String, String> requestHeaders = new HashMap<>();
            requestHeaders.put("X-Naver-Client-Id", clientId);
            requestHeaders.put("X-Naver-Client-Secret", clientSecret);

            String responseBody = callApi(apiURL, requestHeaders);
            
            // [개선 2] API 응답 상태도 확인하여 클라이언트에 전달
            // 이 부분은 Naver API가 에러 발생 시 반환하는 JSON 구조에 따라 커스터마이징할 수 있습니다.
            // 보통 responseBody 안에 errorCode 같은 필드가 있는지 확인하는 로직을 추가하면 좋습니다.
            
            PrintWriter out = response.getWriter();
            out.print(responseBody);
            out.flush();

        } catch (Exception e) {
            // [개선 1] 모든 예외를 여기서 처리하여 클라이언트에게 일관된 오류 메시지를 보냅니다.
            // 서버 로그에는 상세한 예외 정보를 기록하여 디버깅에 활용합니다.
            e.printStackTrace(); // 콘솔에 에러 로그 출력 (실제 운영 환경에서는 로깅 프레임워크 사용 권장)
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요.\"}");
        }
    }

    // [개선] API 호출 관련 메소드들의 이름을 더 명확하게 변경하고, 예외를 호출한 쪽으로 던지도록 수정
    private String callApi(String apiUrl, Map<String, String> requestHeaders) {
        HttpURLConnection con = connect(apiUrl);
        try {
            con.setRequestMethod("GET");
            for (Map.Entry<String, String> header : requestHeaders.entrySet()) {
                con.setRequestProperty(header.getKey(), header.getValue());
            }

            int responseCode = con.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
                return readBody(con.getInputStream());
            } else { // 에러 발생
                return readBody(con.getErrorStream());
            }
        } catch (IOException e) {
            throw new RuntimeException("API 요청과 응답 실패", e);
        } finally {
            con.disconnect();
        }
    }

    private HttpURLConnection connect(String apiUrl) {
        try {
            URL url = new URL(apiUrl);
            return (HttpURLConnection) url.openConnection();
        } catch (MalformedURLException e) {
            throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
        } catch (IOException e) {
            throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
        }
    }

    private String readBody(InputStream body) {
        // [개선 3] InputStreamReader 생성 시 UTF-8 인코딩을 명시적으로 지정
        try (BufferedReader lineReader = new BufferedReader(new InputStreamReader(body, StandardCharsets.UTF_8))) {
            StringBuilder responseBody = new StringBuilder();
            String line;
            while ((line = lineReader.readLine()) != null) {
                responseBody.append(line);
            }
            return responseBody.toString();
        } catch (IOException e) {
            throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
        }
    }
}