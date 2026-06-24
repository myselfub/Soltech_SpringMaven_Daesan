package com.dsan.web.ai.vo;

public class ImgFileVO {
	private byte[] byte_img;
	private String str_img;
	private int building_code;
	private String atch_file_id;
	private int file_sn;
	private String strg_type_cd;
	private String file_cn;
	private String orgnl_file_nm;
	private String file_type;

	public byte[] getByte_img() {
		return byte_img;
	}

	public void setByte_img(byte[] byte_img) {
		this.byte_img = byte_img;
	}

	public String getStr_img() {
		return str_img;
	}

	public void setStr_img(String str_img) {
		this.str_img = str_img;
	}

	public int getBuilding_code() {
		return building_code;
	}

	public void setBuilding_code(int building_code) {
		this.building_code = building_code;
	}

	public String getAtch_file_id() {
		return atch_file_id;
	}

	public void setAtch_file_id(String atch_file_id) {
		this.atch_file_id = atch_file_id;
	}

	public int getFile_sn() {
		return file_sn;
	}

	public void setFile_sn(int file_sn) {
		this.file_sn = file_sn;
	}

	public String getStrg_type_cd() {
		return strg_type_cd;
	}

	public void setStrg_type_cd(String strg_type_cd) {
		this.strg_type_cd = strg_type_cd;
	}

	public String getFile_cn() {
		return file_cn;
	}

	public void setFile_cn(String file_cn) {
		this.file_cn = file_cn;
	}

	public String getOrgnl_file_nm() {
		return orgnl_file_nm;
	}

	public void setOrgnl_file_nm(String orgnl_file_nm) {
		this.orgnl_file_nm = orgnl_file_nm;
	}

	public String getFile_type() {
		return file_type;
	}

	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
}