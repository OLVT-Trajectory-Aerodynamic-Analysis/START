function [] = trimAxis(configs, simSource)
    if (configs.onlyViewAscent)
        [~, apogeeIdx] = max(simSource.position.Zposition);
        apogeeTime = simSource.time(apogeeIdx);
        xlim([-0.1*apogeeTime 1.1*apogeeTime])
    end
end