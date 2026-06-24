package com.dsan.web.cmmn.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CmmnMapper {
	// common
	public List<HashMap<String, Object>> getProcInfoList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getHstnTagList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getHstnTagList2(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getEvntInfoList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getFcltInfoList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getFcltDeatilInfoList(HashMap<String, Object> map);

	public List<HashMap<String, Object>> getDataSourceInfoList(HashMap<String, Object> map);
}