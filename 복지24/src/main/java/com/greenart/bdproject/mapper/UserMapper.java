package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.UserDto;

@Mapper
public interface UserMapper {

    UserDto selectByUsername(@Param("username") String username);

    UserDto selectById(@Param("userId") int userId);

    int insert(UserDto user);

    int update(UserDto user);

    int deleteById(@Param("userId") int userId);

    List<UserDto> selectAll();
}
