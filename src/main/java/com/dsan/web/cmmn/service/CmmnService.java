package com.dsan.web.cmmn.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.cmmn.mapper.CmmnMapper;

@Service
public class CmmnService {
	@Autowired
	private CmmnMapper mapper;

	// COMMON
	public List<HashMap<String, Object>> getProcInfoList(HashMap<String, Object> map) {
		return mapper.getProcInfoList(map);
	}

	public List<HashMap<String, Object>> getHstnTagList(HashMap<String, Object> map) {
		return mapper.getHstnTagList(map);
	}

	public List<HashMap<String, Object>> getHstnTagList2(HashMap<String, Object> map) {
		return mapper.getHstnTagList2(map);
	}

	public List<HashMap<String, Object>> getEvntInfoList(HashMap<String, Object> map) {
		return mapper.getEvntInfoList(map);
	}

	public List<HashMap<String, Object>> getFcltInfoList(HashMap<String, Object> map) {
		return mapper.getFcltInfoList(map);
	}

	public List<HashMap<String, Object>> getFcltDeatilInfoList(HashMap<String, Object> map) {
		return mapper.getFcltDeatilInfoList(map);
	}

	public List<HashMap<String, Object>> getDataSourceInfoList(HashMap<String, Object> map) {
		return mapper.getDataSourceInfoList(map);
	}
}