package com.dsan.web.em.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Em0103Mapper {
	public List<HashMap<String, Object>> getChartStatisticsData(HashMap<String, Object> param);

	public List<HashMap<String, Object>> PwereUsgPrc(HashMap<String, Object> param);

	// 공정별 실시간 전력 조회
	public List<HashMap<String, Object>> getProcsRealTimePower(HashMap<String, Object> param);

	// 공정별 금일 최대 전력 조회
	public List<HashMap<String, Object>> getProcsMaxPower(HashMap<String, Object> param);

	// 공정별 소비 전력량 조회
	public List<HashMap<String, Object>> getProcsPowerUsage(HashMap<String, Object> param);

	// 공정별 소비 요금 조회
	public List<HashMap<String, Object>> getProcsPowerCost(HashMap<String, Object> param);

	// 공정별 시간별 전력량 조회 (차트용)
	public List<HashMap<String, Object>> getProcsHourlyPowerUsage(HashMap<String, Object> param);
}
