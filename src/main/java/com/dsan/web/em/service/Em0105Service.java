package com.dsan.web.em.service;

import com.dsan.web.em.mapper.Em0105Mapper;
import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Em0105Service {
	@Autowired
	private Em0105Mapper mapper;

	public List<HashMap<String, Object>> getGridStatisticsData(HashMap<String, Object> map) {
		return this.mapper.getGridStatisticsData(map);
	}

	public List<HashMap<String, Object>> getGridPwereUsgPrc(HashMap<String, Object> map) {
		return this.mapper.getGridPwereUsgPrc(map);
	}

	// 실시간 전력 조회
	public List<HashMap<String, Object>> getRealTimePower(HashMap<String, Object> map) {
		return this.mapper.getRealTimePower(map);
	}

	// 금일 전력량 조회
	public List<HashMap<String, Object>> getTodayPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getTodayPowerUsage(map);
	}

	// 금일 최대 전력 조회
	public List<HashMap<String, Object>> getTodayMaxPower(HashMap<String, Object> map) {
		return this.mapper.getTodayMaxPower(map);
	}

	// 금일 소비 요금 조회
	public List<HashMap<String, Object>> getTodayPowerCost(HashMap<String, Object> map) {
		return this.mapper.getTodayPowerCost(map);
	}

	// 차트용 시간별 누적 전력량 조회
	public List<HashMap<String, Object>> getChartHourlyPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getChartHourlyPowerUsage(map);
	}

	// 차트용 시간별 소비 요금 조회
	public List<HashMap<String, Object>> getChartHourlyCost(HashMap<String, Object> map) {
		return this.mapper.getChartHourlyCost(map);
	}

	// 시설별 실시간 전력 조회
	public List<HashMap<String, Object>> getFacilityRealTimePower(HashMap<String, Object> map) {
		return this.mapper.getFacilityRealTimePower(map);
	}

	// 시설별 금일 최대 전력 조회
	public List<HashMap<String, Object>> getFacilityMaxPower(HashMap<String, Object> map) {
		return this.mapper.getFacilityMaxPower(map);
	}

	// 시설별 소비 전력량 조회
	public List<HashMap<String, Object>> getFacilityPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getFacilityPowerUsage(map);
	}

	// 시설별 소비 요금 조회
	public List<HashMap<String, Object>> getFacilityPowerCost(HashMap<String, Object> map) {
		return this.mapper.getFacilityPowerCost(map);
	}
	

	// 태양광 태그 현재값 조회
	public List<HashMap<String, Object>> getSolarTagValue(HashMap<String, Object> map) {
		return this.mapper.getSolarTagValue(map);
	}

	// 태양광 시간별 데이터 조회 (차트용)
	public List<HashMap<String, Object>> getHourlySolarData(HashMap<String, Object> map) {
		return this.mapper.getHourlySolarData(map);
	}

	// 일별 누적 전력량 조회 (최근 30일)
	public List<HashMap<String, Object>> getChartDailyPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getChartDailyPowerUsage(map);
	}

	// 월별 누적 전력량 조회 (최근 12개월)
	public List<HashMap<String, Object>> getChartMonthlyPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getChartMonthlyPowerUsage(map);
	}

	// 년도별 누적 전력량 조회 (최근 5년)
	public List<HashMap<String, Object>> getChartYearlyPowerUsage(HashMap<String, Object> map) {
		return this.mapper.getChartYearlyPowerUsage(map);
	}

	// 일별 소비 요금 조회 (최근 30일)
	public List<HashMap<String, Object>> getChartDailyCost(HashMap<String, Object> map) {
		return this.mapper.getChartDailyCost(map);
	}

	// 월별 소비 요금 조회 (최근 12개월)
	public List<HashMap<String, Object>> getChartMonthlyCost(HashMap<String, Object> map) {
		return this.mapper.getChartMonthlyCost(map);
	}

	// 년도별 소비 요금 조회 (최근 5년)
	public List<HashMap<String, Object>> getChartYearlyCost(HashMap<String, Object> map) {
		return this.mapper.getChartYearlyCost(map);
	}

	// 일별 태양광/CO2 데이터 조회 (최근 30일)
	public List<HashMap<String, Object>> getDailySolarData(HashMap<String, Object> map) {
		return this.mapper.getDailySolarData(map);
	}

	// 월별 태양광/CO2 데이터 조회 (최근 12개월)
	public List<HashMap<String, Object>> getMonthlySolarData(HashMap<String, Object> map) {
		return this.mapper.getMonthlySolarData(map);
	}

	// 년도별 태양광/CO2 데이터 조회 (최근 5년)
	public List<HashMap<String, Object>> getYearlySolarData(HashMap<String, Object> map) {
		return this.mapper.getYearlySolarData(map);
	}

	// 금일 전력량 합계 조회 (DB에서 합산)
	public List<HashMap<String, Object>> getTodayPowerUsageTotal(HashMap<String, Object> map) {
		return this.mapper.getTodayPowerUsageTotal(map);
	}
}
