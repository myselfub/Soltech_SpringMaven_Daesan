package com.dsan.web.ai.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.ai.mapper.Ai0102Mapper;
import com.dsan.web.ai.vo.EvntVO;

@Service
public class Ai0102Service {
	@Autowired
	Ai0102Mapper mapper;

	public List<HashMap<String, Object>> getFcltDList(List<HashMap<String, Object>> list) {
		return mapper.getFcltDList(list);
	}

	public List<EvntVO> getEvntList2(HashMap<String, Object> map) {
		return mapper.getEvntList2(map);
	}
}