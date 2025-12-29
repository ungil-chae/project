package com.greenart.bdproject.service;

import java.util.Random;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/**
 * 이메일 발송 서비스
 */
@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Autowired(required = false)
    private JavaMailSender mailSender;

    /**
     * 6자리 인증 코드 생성
     */
    public String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);  // 100000 ~ 999999
        return String.valueOf(code);
    }

    /**
     * 비밀번호 재설정 인증 코드 이메일 발송
     */
    public boolean sendPasswordResetCode(String toEmail, String code) {
        if (mailSender == null) {
            logger.warn("JavaMailSender가 설정되지 않았습니다. 이메일 발송을 건너뜁니다.");
            logger.info("비밀번호 재설정 코드 (테스트): {} -> {}", toEmail, code);
            return true;  // 개발 환경에서는 성공으로 처리
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(toEmail);
            helper.setSubject("[복지24] 비밀번호 재설정 인증 코드");

            String htmlContent = buildPasswordResetEmailContent(code);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            logger.info("비밀번호 재설정 이메일 발송 성공: {}", toEmail);
            return true;

        } catch (MessagingException e) {
            logger.error("이메일 발송 실패: {}", toEmail, e);
            return false;
        }
    }

    /**
     * 비밀번호 재설정 이메일 HTML 내용 생성
     */
    private String buildPasswordResetEmailContent(String code) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Malgun Gothic', sans-serif; line-height: 1.6; color: #333; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background-color: #2196F3; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }" +
                ".content { background-color: #f9f9f9; padding: 30px; border: 1px solid #ddd; }" +
                ".code { font-size: 32px; font-weight: bold; color: #2196F3; text-align: center; " +
                "padding: 20px; background-color: white; border: 2px dashed #2196F3; margin: 20px 0; letter-spacing: 5px; }" +
                ".warning { color: #f44336; font-size: 14px; margin-top: 20px; }" +
                ".footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>복지24 비밀번호 재설정</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p>안녕하세요,</p>" +
                "<p>비밀번호 재설정을 요청하셨습니다. 아래 인증 코드를 입력하여 비밀번호를 재설정하세요.</p>" +
                "<div class='code'>" + code + "</div>" +
                "<p class='warning'>⚠️ 이 코드는 <strong>10분간</strong> 유효합니다.<br>" +
                "본인이 요청하지 않은 경우, 이 이메일을 무시하세요.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>© 2025 복지24. All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }

    /**
     * 회원가입 인증 코드 이메일 발송
     */
    public boolean sendSignupVerificationCode(String toEmail, String code) {
        if (mailSender == null) {
            logger.warn("JavaMailSender가 설정되지 않았습니다. 이메일 발송을 건너뜁니다.");
            logger.info("회원가입 인증 코드 (테스트): {} -> {}", toEmail, code);
            return true;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(toEmail);
            helper.setSubject("[복지24] 회원가입 이메일 인증 코드");

            String htmlContent = buildSignupVerificationEmailContent(code);
            helper.setText(htmlContent, true);

            mailSender.send(message);
            logger.info("회원가입 인증 이메일 발송 성공: {}", toEmail);
            return true;

        } catch (MessagingException e) {
            logger.error("이메일 발송 실패: {}", toEmail, e);
            return false;
        }
    }

    private String buildSignupVerificationEmailContent(String code) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: 'Malgun Gothic', sans-serif; line-height: 1.6; color: #333; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; border-radius: 5px 5px 0 0; }" +
                ".content { background-color: #f9f9f9; padding: 30px; border: 1px solid #ddd; }" +
                ".code { font-size: 32px; font-weight: bold; color: #4CAF50; text-align: center; " +
                "padding: 20px; background-color: white; border: 2px dashed #4CAF50; margin: 20px 0; letter-spacing: 5px; }" +
                ".footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>복지24 회원가입 인증</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p>안녕하세요,</p>" +
                "<p>복지24 회원가입을 환영합니다! 아래 인증 코드를 입력하여 이메일을 인증하세요.</p>" +
                "<div class='code'>" + code + "</div>" +
                "<p>이 코드는 <strong>10분간</strong> 유효합니다.</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>© 2025 복지24. All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}
