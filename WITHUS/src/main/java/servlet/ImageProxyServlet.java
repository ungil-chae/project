// 파일 경로: /프로젝트명/src/main/java/controller/ImageProxyServlet.java

package servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ImageProxyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int BUFFER_SIZE = 4096;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imageUrlParam = request.getParameter("url");
        if (imageUrlParam == null || imageUrlParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Image URL is missing.");
            return;
        }

        // URL 파라미터로 받은 이미지 주소를 디코딩합니다.
        String imageUrl = URLDecoder.decode(imageUrlParam, "UTF-8");

        try {
            URL url = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            
            // 네이버 서버에 요청하는 것처럼 위장하기 위한 Referer 헤더 설정
            connection.setRequestProperty("Referer", "https://www.naver.com");

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // 이미지 타입 설정
                String contentType = connection.getContentType();
                response.setContentType(contentType);

                // 이미지를 클라이언트로 스트리밍
                try (InputStream inputStream = connection.getInputStream();
                     OutputStream outputStream = response.getOutputStream()) {
                    
                    byte[] buffer = new byte[BUFFER_SIZE];
                    int bytesRead;
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }
                }
            } else {
                response.sendError(responseCode);
            }
            connection.disconnect();
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to proxy image.");
            e.printStackTrace();
        }
    }
}