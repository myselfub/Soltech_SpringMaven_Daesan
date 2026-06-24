package com.dsan.web.em.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Em0104Mapper {
	public List<HashMap<String, Object>> getBeforeUntPrcInfo();

	public List<HashMap<String, Object>> getPwrerUntPrcMst(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getPwrerUntMng(HashMap<String, Object> map);

	public int onSaveUntPrc(List<HashMap<String, Object>> list);

	public int onSaveHourSetting(List<HashMap<String, Object>> list);

	public List<HashMap<String, Object>> getUsgPrcValues(HashMap<String, Object> map);
}