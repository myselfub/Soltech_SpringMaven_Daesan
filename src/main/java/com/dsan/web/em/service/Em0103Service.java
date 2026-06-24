package com.dsan.web.em.service;

import com.dsan.web.em.mapper.Em0103Mapper;
import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Em0103Service {
	@Autowired
	private Em0103Mapper mapper;

	public List<HashMap<String, Object>> getChartStatisticsData(HashMap<String, Object> map) {
		return this.mapper.getChartStatisticsData(map);
	}

	public List<HashMap<String, Object>> PwereUsgPrc(HashMap<String, Object> map) {
		return this.mapper.PwereUsgPrc(map);
	}

	// 공정별 실시간 전력 조회
	public List<HashMap<String, Object>> getProcsRealTimePower(HashMap<String, Object> map) {
		return this.mapper.getProcsRealTimePower(map);
	}

	// 공정별 금일 최대 전력 조회
	public List<HashMap<String, Object>> getProcsMaxPower(HashMap<String, Object> map) {
		return this.mapper.getProcsMaxPower(map);
	}

	// 공정별 소비 전력량 조회
	public List<HashMap<String, Object>> getProcsPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getProcsPowerUsage(map);
	}

	// 공정별 소비 요금 조회
	public List<HashMap<String, Object>> getProcsPowerCost(HashMap<String, Object> map) {
		return this.mapper.getProcsPowerCost(map);
	}

	// 공정별 시간별 전력량 조회 (차트용)
	public List<HashMap<String, Object>> getProcsHourlyPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getProcsHourlyPowerUsage(map);
	}
}
