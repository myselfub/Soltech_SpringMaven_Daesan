package com.dsan.web.db.service;

import com.dsan.web.db.mapper.Db0102Mapper;
import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class Db0102Service {
    @Autowired
    private Db0102Mapper mapper;

    // 금일 최근 알람 4건
    public List<HashMap<String, Object>> getAlarmRecent(HashMap<String, Object> map) {
        return this.mapper.getAlarmRecent(map);
    }

    // 금일 태그별 알람 건수 TOP 20
    public List<HashMap<String, Object>> getAlarmTop20(HashMap<String, Object> map) {
        return this.mapper.getAlarmTop20(map);
    }

    // 약품 사용현황
    public List<HashMap<String, Object>> getChemicalUsage(HashMap<String, Object> map) {
        return this.mapper.getChemicalUsage(map);
    }

    // 물생산량
    public List<HashMap<String, Object>> getHourlyWaterProduction(HashMap<String, Object> map) {
        return this.mapper.getHourlyWaterProduction(map);
    }
    public List<HashMap<String, Object>> getDailyWaterProduction(HashMap<String, Object> map) {
        return this.mapper.getDailyWaterProduction(map);
    }
    public List<HashMap<String, Object>> getMonthlyWaterProduction(HashMap<String, Object> map) {
        return this.mapper.getMonthlyWaterProduction(map);
    }
    public List<HashMap<String, Object>> getYearlyWaterProduction(HashMap<String, Object> map) {
        return this.mapper.getYearlyWaterProduction(map);
    }

    // 전력원단위
    public List<HashMap<String, Object>> getHourlyPowerIntensity(HashMap<String, Object> map) {
        return this.mapper.getHourlyPowerIntensity(map);
    }
    public List<HashMap<String, Object>> getDailyPowerIntensity(HashMap<String, Object> map) {
        return this.mapper.getDailyPowerIntensity(map);
    }
    public List<HashMap<String, Object>> getMonthlyPowerIntensity(HashMap<String, Object> map) {
        return this.mapper.getMonthlyPowerIntensity(map);
    }
    public List<HashMap<String, Object>> getYearlyPowerIntensity(HashMap<String, Object> map) {
        return this.mapper.getYearlyPowerIntensity(map);
    }

    // 약품사용량
    public List<HashMap<String, Object>> getDailyChemicalUsage(HashMap<String, Object> map) {
        return this.mapper.getDailyChemicalUsage(map);
    }
    public List<HashMap<String, Object>> getMonthlyChemicalUsage(HashMap<String, Object> map) {
        return this.mapper.getMonthlyChemicalUsage(map);
    }
    public List<HashMap<String, Object>> getYearlyChemicalUsage(HashMap<String, Object> map) {
        return this.mapper.getYearlyChemicalUsage(map);
    }

    // 생산수 수질 (최신 1분 데이터)
    public List<HashMap<String, Object>> getWaterQualityLatest(HashMap<String, Object> map) {
        return this.mapper.getWaterQualityLatest(map);
    }
}
