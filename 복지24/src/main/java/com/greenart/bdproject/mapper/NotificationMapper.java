package com.greenart.bdproject.mapper;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.Notification;

@Mapper
public interface NotificationMapper {

    Long create(Notification notification);

    List<Notification> findByUserId(@Param("userId") String userId);

    int markAsRead(@Param("notificationId") Long notificationId);

    int markAllAsRead(@Param("userId") String userId);

    int delete(@Param("notificationId") Long notificationId);

    int deleteAll(@Param("userId") String userId);

    int countUnread(@Param("userId") String userId);

    boolean existsByUserAndEventDate(@Param("userId") String userId,
                                     @Param("type") String type,
                                     @Param("eventDate") Date eventDate,
                                     @Param("title") String title);

    int deleteByUserIdAndTypes(@Param("userId") String userId,
                               @Param("notificationTypes") List<String> notificationTypes);
}
