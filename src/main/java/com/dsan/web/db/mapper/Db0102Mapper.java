package com.dsan.web.db.mapper;

import java.util.HashMap;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface Db0102Mapper {
    // 금일 최근 알람 4건
    public List<HashMap<String, Object>> getAlarmRecent(HashMap<String, Object> param);

    // 금일 태그별 알람 건수 TOP 20
    public List<HashMap<String, Object>> getAlarmTop20(HashMap<String, Object> param);

    // 약품 사용현황
    public List<HashMap<String, Object>> getChemicalUsage(HashMap<String, Object> param);

    // 물생산량 (시간별/일별/월별/년도별)
    public List<HashMap<String, Object>> getHourlyWaterProduction(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getDailyWaterProduction(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getMonthlyWaterProduction(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getYearlyWaterProduction(HashMap<String, Object> param);

    // 전력원단위 (시간별/일별/월별/년도별)
    public List<HashMap<String, Object>> getHourlyPowerIntensity(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getDailyPowerIntensity(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getMonthlyPowerIntensity(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getYearlyPowerIntensity(HashMap<String, Object> param);

    // 약품사용량 (일별/월별/년도별)
    public List<HashMap<String, Object>> getDailyChemicalUsage(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getMonthlyChemicalUsage(HashMap<String, Object> param);
    public List<HashMap<String, Object>> getYearlyChemicalUsage(HashMap<String, Object> param);

    // 생산수 수질 (최신 1분 데이터)
    public List<HashMap<String, Object>> getWaterQualityLatest(HashMap<String, Object> param);
}
