package com.greenart.bdproject;

import java.util.Date;
import java.util.Objects;

public class BoardDto {
	private Integer bno;
	private String title;
	private String content;
	private String writer;
	private int viewCnt;
	private int commenCnt;
	public BoardDto(String title, String content, String writer) {
		super();
		this.title = title;
		this.content = content;
		this.writer = writer;
	}
	private Date regDate;
	private Date modiDate;
	public Integer getBno() {
		return bno;
	}
	public void setBno(Integer bno) {
		this.bno = bno;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public int getViewCnt() {
		return viewCnt;
	}
	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}
	public int getCommenCnt() {
		return commenCnt;
	}
	public void setCommenCnt(int commenCnt) {
		this.commenCnt = commenCnt;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public Date getModiDate() {
		return modiDate;
	}
	public void setModiDate(Date modiDate) {
		this.modiDate = modiDate;
	}
	@Override
	public String toString() {
		return "BoardDto [bno=" + bno + ", title=" + title + ", content=" + content + ", writer=" + writer
				+ ", viewCnt=" + viewCnt + ", commenCnt=" + commenCnt + ", regDate=" + regDate + ", modiDate="
				+ modiDate + "]";
	}
	@Override
	public int hashCode() {
		return Objects.hash(bno, content, title, writer);
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		BoardDto other = (BoardDto) obj;
		return Objects.equals(bno, other.bno) && Objects.equals(content, other.content)
				&& Objects.equals(title, other.title) && Objects.equals(writer, other.writer);
	}
}
