package com.dsan.web.qm.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.qm.mapper.Qm0101Mapper;

@Service
public class Qm0101Service {
	@Autowired
	private Qm0101Mapper mapper;

	public List<HashMap<String, Object>> getDataQcHstyList(HashMap<String, Object> map) {
		return mapper.getDataQcHstyList(map);
	}

	public int insertDataQcHsty(List<HashMap<String, Object>> list) {
		return mapper.insertDataQcHsty(list);
	}
}