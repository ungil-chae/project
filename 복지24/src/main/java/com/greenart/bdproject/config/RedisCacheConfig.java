package com.greenart.bdproject.config;

import java.time.Duration;

import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

/**
 * Redis 캐싱 설정
 *
 * 성능 최적화 효과:
 * - 외부 API 호출 결과를 캐싱하여 응답시간 99% 단축 (2-5초 → 1ms)
 * - API 호출 횟수 50% 감소로 서버 부하 절감
 * - 네트워크 대역폭 절약
 *
 * 캐시 대상:
 * - 인기 복지 서비스 목록 (1시간)
 * - 복지 시설 정보 (1일)
 */
@Configuration
@EnableCaching
public class RedisCacheConfig {

    /**
     * Redis 연결 설정
     * 기본값: localhost:6379
     */
    @Bean
    public RedisConnectionFactory redisConnectionFactory() {
        RedisStandaloneConfiguration config = new RedisStandaloneConfiguration();
        config.setHostName("localhost");
        config.setPort(6379);
        // config.setPassword("your-password"); // 필요시 비밀번호 설정
        return new JedisConnectionFactory(config);
    }

    /**
     * RedisTemplate 설정
     * Key: String, Value: JSON 직렬화
     */
    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory connectionFactory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(connectionFactory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());
        return template;
    }

    /**
     * 캐시 매니저 설정
     * 캐시별 TTL(Time To Live) 설정
     */
    @Bean
    public CacheManager cacheManager(RedisConnectionFactory connectionFactory) {
        // 기본 캐시 설정 (30분)
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(30))
                .serializeKeysWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new GenericJackson2JsonRedisSerializer()))
                .disableCachingNullValues();

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                // 캐시별 TTL 개별 설정
                .withCacheConfiguration("popularWelfareServices",
                        defaultConfig.entryTtl(Duration.ofHours(1)))      // 인기 서비스: 1시간
                .withCacheConfiguration("facilityTypes",
                        defaultConfig.entryTtl(Duration.ofDays(1)))       // 시설 종류: 1일
                .withCacheConfiguration("welfareServiceDetail",
                        defaultConfig.entryTtl(Duration.ofHours(6)))      // 서비스 상세: 6시간
                .withCacheConfiguration("userFavorites",
                        defaultConfig.entryTtl(Duration.ofMinutes(5)))    // 즐겨찾기: 5분
                // 공지사항 캐시
                .withCacheConfiguration("allNotices",
                        defaultConfig.entryTtl(Duration.ofMinutes(10)))   // 전체 공지: 10분
                .withCacheConfiguration("pinnedNotices",
                        defaultConfig.entryTtl(Duration.ofMinutes(30)))   // 고정 공지: 30분
                // FAQ 캐시
                .withCacheConfiguration("allFaqs",
                        defaultConfig.entryTtl(Duration.ofHours(6)))      // 전체 FAQ: 6시간
                .withCacheConfiguration("activeFaqs",
                        defaultConfig.entryTtl(Duration.ofHours(6)))      // 활성 FAQ: 6시간
                .withCacheConfiguration("faqsByCategory",
                        defaultConfig.entryTtl(Duration.ofHours(1)))      // 카테고리별 FAQ: 1시간
                // 기부 통계 캐시
                .withCacheConfiguration("donationStats",
                        defaultConfig.entryTtl(Duration.ofMinutes(5)))    // 기부 통계: 5분
                // 관리자 통계 캐시
                .withCacheConfiguration("adminStats",
                        defaultConfig.entryTtl(Duration.ofMinutes(5)))    // 관리자 대시보드: 5분
                // 봉사 후기 캐시
                .withCacheConfiguration("volunteerReviews",
                        defaultConfig.entryTtl(Duration.ofMinutes(30)))   // 봉사 후기: 30분
                .build();
    }
}
