package com.dsan.web.qm.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.qm.mapper.Qm0102Mapper;

@Service
public class Qm0102Service {
	@Autowired
	private Qm0102Mapper mapper;

	public List<HashMap<String, Object>> getDataQcHstyList2(HashMap<String, Object> map) {
		return mapper.getDataQcHstyList2(map);
	}

	public List<HashMap<String, Object>> getHstnTagList_hasRevisnlog(HashMap<String, Object> map) {
		return mapper.getHstnTagList_hasRevisnlog(map);
	}
}