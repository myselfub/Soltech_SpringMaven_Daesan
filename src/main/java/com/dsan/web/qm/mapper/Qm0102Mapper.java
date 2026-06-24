package com.dsan.web.qm.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Qm0102Mapper {
	public List<HashMap<String, Object>> getDataQcHstyList2(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getHstnTagList_hasRevisnlog(HashMap<String, Object> map);
}