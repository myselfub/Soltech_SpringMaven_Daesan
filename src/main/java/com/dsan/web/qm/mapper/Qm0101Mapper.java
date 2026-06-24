package com.dsan.web.qm.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Qm0101Mapper {
	public List<HashMap<String, Object>> getDataQcHstyList(HashMap<String, Object> map);

	public int insertDataQcHsty(List<HashMap<String, Object>> list);
}