const _ZSERI_WR = Array(Float64,2)
const _ZSERI_WI = Array(Float64,2)
function ZSERI(ZR::Float64,ZI::Float64,FNU::Float64,KODE::Integer,N::Integer,YR::AbstractArray{Float64},YI::AbstractArray{Float64},NZ::Integer,TOL::Float64,ELIM::Float64,ALIM::Float64)
    AA::Float64 = 0
    ACZ::Float64 = 0
    AK::Float64 = 0
    AK1I::Float64 = 0
    AK1R::Float64 = 0
    ARM::Float64 = 0
    ASCLE::Float64 = 0
    ATOL::Float64 = 0
    AZ::Float64 = 0
    CKI::Float64 = 0
    CKR::Float64 = 0
    COEFI::Float64 = 0
    COEFR::Float64 = 0
    CONEI::Float64 = 0
    CONER::Float64 = 0
    CRSCR::Float64 = 0
    CZI::Float64 = 0
    CZR::Float64 = 0
    DFNU::Float64 = 0
    FNUP::Float64 = 0
    HZI::Float64 = 0
    HZR::Float64 = 0
    I::Int32 = 0
    IB::Int32 = 0
    IDUM::Int32 = 0
    IFLAG::Int32 = 0
    IL::Int32 = 0
    K::Int32 = 0
    L::Int32 = 0
    M::Int32 = 0
    NN::Int32 = 0
    NW::Int32 = 0
    RAZ::Float64 = 0
    RS::Float64 = 0
    RTR1::Float64 = 0
    RZI::Float64 = 0
    RZR::Float64 = 0
    S::Float64 = 0
    S1I::Float64 = 0
    S1R::Float64 = 0
    S2I::Float64 = 0
    S2R::Float64 = 0
    SS::Float64 = 0
    STI::Float64 = 0
    STR::Float64 = 0
    const WI = _ZSERI_WI
    const WR = _ZSERI_WR
    ZEROI::Float64 = 0
    ZEROR::Float64 = 0
    begin 
        ZEROR = 0.0
        ZEROI = 0.0
        CONER = 1.0
        CONEI = 0.0
    end
    NZ = 0
    AZ = ZABS(COMPLEX(ZR,ZI))
    if AZ == 0.0
        @goto line160
    end
    ARM = 1000.0D1MACH1
    RTR1 = DSQRT(ARM)
    CRSCR = 1.0
    IFLAG = 0
    if AZ < ARM
        @goto line150
    end
    HZR = 0.5ZR
    HZI = 0.5ZI
    CZR = ZEROR
    CZI = ZEROI
    if AZ <= RTR1
        @goto line10
    end
    (CZR,CZI) = ZMLT(HZR,HZI,HZR,HZI,CZR,CZI)
    @label line10
    ACZ = ZABS(COMPLEX(CZR,CZI))
    NN = N
    (CKR,CKI,IDUM) = ZLOG(HZR,HZI,CKR,CKI,IDUM)
    @label line20
    DFNU = FNU + DBLE(FLOAT(NN - 1))
    FNUP = DFNU + 1.0
    AK1R = CKR * DFNU
    AK1I = CKI * DFNU
    AK = DGAMLN(FNUP,IDUM)
    AK1R = AK1R - AK
    if KODE == 2
        AK1R = AK1R - ZR
    end
    if AK1R > -ELIM
        @goto line40
    end
    @label line30
    NZ = NZ + 1
    YR[NN] = ZEROR
    YI[NN] = ZEROI
    if ACZ > DFNU
        @goto line190
    end
    NN = NN - 1
    if NN == 0
        return NZ
    end
    @goto line20
    @label line40
    if AK1R > -ALIM
        @goto line50
    end
    IFLAG = 1
    SS = 1.0 / TOL
    CRSCR = TOL
    ASCLE = ARM * SS
    @label line50
    AA = DEXP(AK1R)
    if IFLAG == 1
        AA = AA * SS
    end
    COEFR = AA * DCOS(AK1I)
    COEFI = AA * DSIN(AK1I)
    ATOL = (TOL * ACZ) / FNUP
    IL = MIN0(2,NN)
    for I = 1:IL
        DFNU = FNU + DBLE(FLOAT(NN - I))
        FNUP = DFNU + 1.0
        S1R = CONER
        S1I = CONEI
        if ACZ < TOL * FNUP
            @goto line70
        end
        AK1R = CONER
        AK1I = CONEI
        AK = FNUP + 2.0
        S = FNUP
        AA = 2.0
        @label line60
        RS = 1.0 / S
        STR = AK1R * CZR - AK1I * CZI
        STI = AK1R * CZI + AK1I * CZR
        AK1R = STR * RS
        AK1I = STI * RS
        S1R = S1R + AK1R
        S1I = S1I + AK1I
        S = S + AK
        AK = AK + 2.0
        AA = AA * ACZ * RS
        if AA > ATOL
            @goto line60
        end
        @label line70
        S2R = S1R * COEFR - S1I * COEFI
        S2I = S1R * COEFI + S1I * COEFR
        WR[I] = S2R
        WI[I] = S2I
        if IFLAG == 0
            @goto line80
        end
        (NW,) = ZUCHK(S2R,S2I,NW,ASCLE,TOL)
        if NW != 0
            @goto line30
        end
        @label line80
        M = (NN - I) + 1
        YR[M] = S2R * CRSCR
        YI[M] = S2I * CRSCR
        if I == IL
            @goto line90
        end
        (STR,STI) = ZDIV(COEFR,COEFI,HZR,HZI,STR,STI)
        COEFR = STR * DFNU
        COEFI = STI * DFNU
        @label line90
    end
    if NN <= 2
        return NZ
    end
    K = NN - 2
    AK = DBLE(FLOAT(K))
    RAZ = 1.0 / AZ
    STR = ZR * RAZ
    STI = -ZI * RAZ
    RZR = (STR + STR) * RAZ
    RZI = (STI + STI) * RAZ
    if IFLAG == 1
        @goto line120
    end
    IB = 3
    @label line100
    for I = IB:NN
        YR[K] = (AK + FNU) * (RZR * YR[K + 1] - RZI * YI[K + 1]) + YR[K + 2]
        YI[K] = (AK + FNU) * (RZR * YI[K + 1] + RZI * YR[K + 1]) + YI[K + 2]
        AK = AK - 1.0
        K = K - 1
        @label line110
    end
    return NZ
    @label line120
    S1R = WR[1]
    S1I = WI[1]
    S2R = WR[2]
    S2I = WI[2]
    for L = 3:NN
        CKR = S2R
        CKI = S2I
        S2R = S1R + (AK + FNU) * (RZR * CKR - RZI * CKI)
        S2I = S1I + (AK + FNU) * (RZR * CKI + RZI * CKR)
        S1R = CKR
        S1I = CKI
        CKR = S2R * CRSCR
        CKI = S2I * CRSCR
        YR[K] = CKR
        YI[K] = CKI
        AK = AK - 1.0
        K = K - 1
        if ZABS(COMPLEX(CKR,CKI)) > ASCLE
            @goto line140
        end
        @label line130
    end
    return NZ
    @label line140
    IB = L + 1
    if IB > NN
        return NZ
    end
    @goto line100
    @label line150
    NZ = N
    if FNU == 0.0
        NZ = NZ - 1
    end
    @label line160
    YR[1] = ZEROR
    YI[1] = ZEROI
    if FNU != 0.0
        @goto line170
    end
    YR[1] = CONER
    YI[1] = CONEI
    @label line170
    if N == 1
        return NZ
    end
    for I = 2:N
        YR[I] = ZEROR
        YI[I] = ZEROI
        @label line180
    end
    return NZ
    @label line190
    NZ = -NZ
    return NZ
end
