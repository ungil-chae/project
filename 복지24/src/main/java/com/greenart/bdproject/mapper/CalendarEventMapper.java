package com.greenart.bdproject.mapper;

import java.sql.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.CalendarEvent;

@Mapper
public interface CalendarEventMapper {

    Long insert(CalendarEvent event);

    int update(CalendarEvent event);

    int delete(@Param("eventId") Long eventId);

    CalendarEvent selectById(@Param("eventId") Long eventId);

    List<CalendarEvent> selectByMemberId(@Param("memberId") Long memberId);

    List<CalendarEvent> selectByMemberIdAndDate(@Param("memberId") Long memberId,
                                                 @Param("eventDate") Date eventDate);

    List<CalendarEvent> selectByMemberIdAndDateRange(@Param("memberId") Long memberId,
                                                      @Param("startDate") Date startDate,
                                                      @Param("endDate") Date endDate);

    int updateStatus(@Param("eventId") Long eventId, @Param("status") String status);

    int deleteAllByMemberId(@Param("memberId") Long memberId);
}
