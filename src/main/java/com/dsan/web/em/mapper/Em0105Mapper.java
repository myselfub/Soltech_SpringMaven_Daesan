package com.dsan.web.em.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Em0105Mapper {
	public List<HashMap<String, Object>> getGridStatisticsData(HashMap<String, Object> param);

	public List<HashMap<String, Object>> getGridPwereUsgPrc(HashMap<String, Object> param);

	// 실시간 전력 조회
	public List<HashMap<String, Object>> getRealTimePower(HashMap<String, Object> param);

	// 금일 전력량 조회
	public List<HashMap<String, Object>> getTodayPowerUsage(HashMap<String, Object> param);

	// 금일 최대 전력 조회
	public List<HashMap<String, Object>> getTodayMaxPower(HashMap<String, Object> param);

	// 금일 소비 요금 조회
	public List<HashMap<String, Object>> getTodayPowerCost(HashMap<String, Object> param);

	// 차트용 시간별 누적 전력량 조회
	public List<HashMap<String, Object>> getChartHourlyPowerUsage(HashMap<String, Object> param);

	// 차트용 시간별 소비 요금 조회
	public List<HashMap<String, Object>> getChartHourlyCost(HashMap<String, Object> param);

	// 시설별 실시간 전력 조회
	public List<HashMap<String, Object>> getFacilityRealTimePower(HashMap<String, Object> param);

	// 시설별 금일 최대 전력 조회
	public List<HashMap<String, Object>> getFacilityMaxPower(HashMap<String, Object> param);

	// 시설별 소비 전력량 조회
	public List<HashMap<String, Object>> getFacilityPowerUsage(HashMap<String, Object> param);

	// 시설별 소비 요금 조회
	public List<HashMap<String, Object>> getFacilityPowerCost(HashMap<String, Object> param);
	

	// 태양광 태그 현재값 조회
	public List<HashMap<String, Object>> getSolarTagValue(HashMap<String, Object> param);

	// 태양광 시간별 데이터 조회 (차트용)
	public List<HashMap<String, Object>> getHourlySolarData(HashMap<String, Object> param);

	// 일별 누적 전력량 조회 (최근 30일)
	public List<HashMap<String, Object>> getChartDailyPowerUsage(HashMap<String, Object> param);

	// 월별 누적 전력량 조회 (최근 12개월)
	public List<HashMap<String, Object>> getChartMonthlyPowerUsage(HashMap<String, Object> param);

	// 년도별 누적 전력량 조회 (최근 5년)
	public List<HashMap<String, Object>> getChartYearlyPowerUsage(HashMap<String, Object> param);

	// 일별 소비 요금 조회 (최근 30일)
	public List<HashMap<String, Object>> getChartDailyCost(HashMap<String, Object> param);

	// 월별 소비 요금 조회 (최근 12개월)
	public List<HashMap<String, Object>> getChartMonthlyCost(HashMap<String, Object> param);

	// 년도별 소비 요금 조회 (최근 5년)
	public List<HashMap<String, Object>> getChartYearlyCost(HashMap<String, Object> param);

	// 일별 태양광/CO2 데이터 조회 (최근 30일)
	public List<HashMap<String, Object>> getDailySolarData(HashMap<String, Object> param);

	// 월별 태양광/CO2 데이터 조회 (최근 12개월)
	public List<HashMap<String, Object>> getMonthlySolarData(HashMap<String, Object> param);

	// 년도별 태양광/CO2 데이터 조회 (최근 5년)
	public List<HashMap<String, Object>> getYearlySolarData(HashMap<String, Object> param);

	// 금일 전력량 합계 조회 (DB에서 합산)
	public List<HashMap<String, Object>> getTodayPowerUsageTotal(HashMap<String, Object> param);
}
