package com.dsan.web.qm.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dsan.web.qm.mapper.Qm0103Mapper;
import com.dsan.web.qm.vo.RuleVO;

@Service
public class Qm0103Service {
	@Autowired
	private Qm0103Mapper mapper;

	public List<RuleVO> getRuleList() {
		return mapper.getRuleList();
	}
}