package com.dsan.web.ai.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.dsan.web.ai.vo.EvntVO;

@Mapper
public interface Ai0102Mapper {
	public List<HashMap<String, Object>> getFcltDList(List<HashMap<String, Object>> list);

	public List<EvntVO> getEvntList2(HashMap<String, Object> map);
}