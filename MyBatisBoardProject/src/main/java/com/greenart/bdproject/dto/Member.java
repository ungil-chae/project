package com.greenart.bdproject.dto;

import java.util.Date;
import java.util.Objects;

public class Member {
	private String id;
	private String pwd;
	private String name;
	private String email;
	private java.sql.Date birth;
	private String sns;
	private Date regDate;
	
    // 기본 생성자 추가
    public Member() {
    }

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public java.sql.Date getBirth() {
		return birth;
	}
	public void setBirth(java.sql.Date birth) {
		this.birth = birth;
	}
	public String getSns() {
		return sns;
	}
	public void setSns(String sns) {
		this.sns = sns;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
    public Member(String id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
    }
    
    // 🚩 pwd를 포함하는 생성자 추가
    public Member(String id, String pwd, String name, String email) {
        this.id = id;
        this.pwd = pwd;
        this.name = name;
        this.email = email;
    }

	@Override
	public String toString() {
		return "Member [id=" + id + ", pwd=" + pwd + ", name=" + name + ", email=" + email + ", birth=" + birth
				+ ", sns=" + sns + ", regDate=" + regDate + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(birth, email, id, name, pwd);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Member other = (Member) obj;
		return Objects.equals(birth, other.birth) && Objects.equals(email, other.email) && Objects.equals(id, other.id)
				&& Objects.equals(name, other.name) && Objects.equals(pwd, other.pwd);
	}
}