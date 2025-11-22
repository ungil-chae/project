package com.greenart.bdproject.dto;

import java.util.Date;
import java.util.Objects;

/*
 * CREATE TABLE `board` (
  `bno` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `writer` varchar(10) NOT NULL,
  `viewCnt` int DEFAULT '0',
  `commentCnt` int DEFAULT '0',
  `regDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `modiDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bno`)
);

 */
public class BoardDto {
	private Integer bno; //  null -> int / Integer null값 처리를 위해서
	private String title;
	private String content;
	private String writer;
	private int viewCnt;
	private int commentCnt;
	private Date regDate; // java.util.Date
	private Date modiDate;
	
	
	public BoardDto(String title, String content, String writer) {
		super();
		this.title = title;
		this.content = content;
		this.writer = writer;
	}
	
	
	public BoardDto() {
		super();
		// TODO Auto-generated constructor stub
	}


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
	public int getCommentCnt() {
		return commentCnt;
	}
	public void setCommentCnt(int commentCnt) {
		this.commentCnt = commentCnt;
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
				+ ", viewCnt=" + viewCnt + ", commentCnt=" + commentCnt + ", regDate=" + regDate + ", modiDate="
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
