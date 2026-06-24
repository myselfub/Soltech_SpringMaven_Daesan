package com.dsan.web.em.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.em.mapper.Em0104Mapper;

@Service
public class Em0104Service {
	@Autowired
	private Em0104Mapper mapper;

	public List<HashMap<String, Object>> getBeforeUntPrcInfo() {
		return mapper.getBeforeUntPrcInfo();
	}

	public List<HashMap<String, Object>> getPwrerUntPrcMst(HashMap<String, Object> map) {
		return mapper.getPwrerUntPrcMst(map);
	}

	public List<HashMap<String, Object>> getPwrerUntMng(HashMap<String, Object> map) {
		return mapper.getPwrerUntMng(map);
	}

	public int onSaveUntPrc(List<HashMap<String, Object>> list) {
		return mapper.onSaveUntPrc(list);
	}

	public int onSaveHourSetting(List<HashMap<String, Object>> list) {
		return mapper.onSaveHourSetting(list);
	}

	public List<HashMap<String, Object>> getUsgPrcValues(HashMap<String, Object> map) {
		return mapper.getUsgPrcValues(map);
	}
}