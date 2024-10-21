FuelConsumptionLevelPerTick = 0.05 -- 1.0 = 10% per second

BasicFuelTankCapacity = 65
VehicleClassFuelTankMultiplier = {
    [0] = 0.69,   -- Compact (45 / 65)
    [1] = 0.92,   -- Sedans (60 / 65)
    [2] = 1.23,   -- SUVs (80 / 65)
    [3] = 1.08,   -- Coupes (70 / 65)
    [4] = 0.77,   -- Muscle (50 / 65)
    [5] = 1.38,   -- Sports Classics (90 / 65)
    [6] = 1.38,   -- Sports (90 / 65)
    [7] = 1.54,   -- Super (100 / 65)
    [8] = 1.08,   -- Motorcycles (70 / 65)
    [9] = 2.31,   -- Off-road (150 / 65)
    [10] = 1.85,  -- Industrial (120 / 65)
    [11] = 1.54,  -- Utility (100 / 65)
    [12] = 1.38,  -- Vans (90 / 65)
    [13] = 0.92,  -- Cycles (60 / 65)
    [14] = 0.31,  -- Boats (20 / 65)
    [15] = 0.62,  -- Helicopters (40 / 65)
    [16] = 0.62,  -- Planes (40 / 65)
    [17] = 1.54,  -- Service (100 / 65)
    [18] = 1.54,  -- Emergency (100 / 65)
    [19] = 3.08,  -- Military (200 / 65)
    [20] = 1.85,  -- Commercial (120 / 65)
    [21] = 2.77,  -- Trains (180 / 65)
    [22] = 1.54,  -- Open Wheel (100 / 65)
}

ClassFuelEconomy = {
    [0] = 0.6,   -- Compact (lower consumption)
    [1] = 0.8,   -- Sedans (moderate consumption)
    [2] = 1.0,   -- SUVs (average consumption)
    [3] = 0.9,   -- Coupes (slightly less consumption)
    [4] = 1.2,   -- Muscle (bigger engines, higher consumption)
    [5] = 1.1,   -- Sports Classics (slightly higher consumption)
    [6] = 1.0,   -- Sports (standard consumption)
    [7] = 1.3,   -- Super (very fast, higher consumption)
    [8] = 0.3,   -- Motorcycles (very economical)
    [9] = 1.5,   -- Off-road (heavier, higher consumption)
    [10] = 1.7,  -- Industrial (heavy vehicles, high consumption)
    [11] = 1.2,  -- Utility (standard consumption)
    [12] = 1.0,  -- Vans (similar to SUVs)
    [13] = 0.0,  -- Cycles (no fuel consumption)
    [14] = 0.8,  -- Boats (moderate consumption)
    [15] = 1.5,  -- Helicopters (high consumption)
    [16] = 1.5,  -- Planes (high consumption)
    [17] = 0.6,  -- Service (less consumption)
    [18] = 1.0,  -- Emergency (average consumption)
    [19] = 2.0,  -- Military (military vehicles, high consumption)
    [20] = 1.8,  -- Commercial (heavy vehicles, high consumption)
    [21] = 0.0,  -- Trains (no fuel consumption)
    [22] = 1.4,  -- Open Wheel (Formula 1, higher consumption)
}

FuelUsagePerRPM = {
    [1.0] = 1.00,
    [0.9] = 0.90,
    [0.8] = 0.80,
    [0.7] = 0.70,
    [0.6] = 0.60,
    [0.5] = 0.50,
    [0.4] = 0.40,
    [0.3] = 0.30,
    [0.2] = 0.20,
    [0.1] = 0.10,
    [0.0] = 0.00,
}