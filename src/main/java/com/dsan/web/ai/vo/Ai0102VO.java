package com.dsan.web.ai.vo;

import java.util.HashMap;
import java.util.List;

public class Ai0102VO {
	private List<HashMap<String, Object>> procs_list;
	private List<HashMap<String, Object>> fclt_list;
	private List<HashMap<String, Object>> fclt_dtl_list;
	private List<HashMap<String, Object>> evnt_se_list;
	private String bgng_dt;
	private String end_dt;

	public List<HashMap<String, Object>> getProcs_list() {
		return procs_list;
	}

	public void setProcs_list(List<HashMap<String, Object>> procs_list) {
		this.procs_list = procs_list;
	}

	public List<HashMap<String, Object>> getFclt_list() {
		return fclt_list;
	}

	public void setFclt_list(List<HashMap<String, Object>> fclt_list) {
		this.fclt_list = fclt_list;
	}

	public List<HashMap<String, Object>> getFclt_dtl_list() {
		return fclt_dtl_list;
	}

	public void setFclt_dtl_list(List<HashMap<String, Object>> fclt_dtl_list) {
		this.fclt_dtl_list = fclt_dtl_list;
	}

	public List<HashMap<String, Object>> getEvnt_se_list() {
		return evnt_se_list;
	}

	public void setEvnt_se_list(List<HashMap<String, Object>> evnt_se_list) {
		this.evnt_se_list = evnt_se_list;
	}

	public String getBgng_dt() {
		return bgng_dt;
	}

	public void setBgng_dt(String bgng_dt) {
		this.bgng_dt = bgng_dt;
	}

	public String getEnd_dt() {
		return end_dt;
	}

	public void setEnd_dt(String end_dt) {
		this.end_dt = end_dt;
	}
}