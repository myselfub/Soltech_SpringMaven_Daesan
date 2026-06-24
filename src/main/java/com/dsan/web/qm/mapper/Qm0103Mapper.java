package com.dsan.web.qm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.dsan.web.qm.vo.RuleVO;

@Mapper
public interface Qm0103Mapper {
	public List<RuleVO> getRuleList();
}