const _ZUOIK_CWRKR = Array(Float64,16)
const _ZUOIK_CWRKI = Array(Float64,16)
function ZUOIK(ZR::Float64,ZI::Float64,FNU::Float64,KODE::Integer,IKFLG::Integer,N::Integer,YR::AbstractArray{Float64},YI::AbstractArray{Float64},NUF::Integer,TOL::Float64,ELIM::Float64,ALIM::Float64)
    AARG::Float64 = 0
    AIC::Float64 = 0
    APHI::Float64 = 0
    ARGI::Float64 = 0
    ARGR::Float64 = 0
    ASCLE::Float64 = 0
    ASUMI::Float64 = 0
    ASUMR::Float64 = 0
    AX::Float64 = 0
    AY::Float64 = 0
    BSUMI::Float64 = 0
    BSUMR::Float64 = 0
    const CWRKI = _ZUOIK_CWRKI
    const CWRKR = _ZUOIK_CWRKR
    CZI::Float64 = 0
    CZR::Float64 = 0
    FNN::Float64 = 0
    GNN::Float64 = 0
    GNU::Float64 = 0
    I::Int32 = 0
    IDUM::Int32 = 0
    IFORM::Int32 = 0
    INIT::Int32 = 0
    NN::Int32 = 0
    NW::Int32 = 0
    PHII::Float64 = 0
    PHIR::Float64 = 0
    RCZ::Float64 = 0
    STI::Float64 = 0
    STR::Float64 = 0
    SUMI::Float64 = 0
    SUMR::Float64 = 0
    ZBI::Float64 = 0
    ZBR::Float64 = 0
    ZEROI::Float64 = 0
    ZEROR::Float64 = 0
    ZETA1I::Float64 = 0
    ZETA1R::Float64 = 0
    ZETA2I::Float64 = 0
    ZETA2R::Float64 = 0
    ZNI::Float64 = 0
    ZNR::Float64 = 0
    ZRI::Float64 = 0
    ZRR::Float64 = 0
    begin 
        ZEROR = 0.0
        ZEROI = 0.0
    end
    begin 
        AIC = 1.2655121234846454
    end
    NUF = 0
    NN = N
    ZRR = ZR
    ZRI = ZI
    if ZR >= 0.0
        @goto line10
    end
    ZRR = -ZR
    ZRI = -ZI
    @label line10
    ZBR = ZRR
    ZBI = ZRI
    AX = DABS(ZR) * 1.7321
    AY = DABS(ZI)
    IFORM = 1
    if AY > AX
        IFORM = 2
    end
    GNU = DMAX1(FNU,1.0)
    if IKFLG == 1
        @goto line20
    end
    FNN = DBLE(FLOAT(NN))
    GNN = (FNU + FNN) - 1.0
    GNU = DMAX1(GNN,FNN)
    @label line20
    if IFORM == 2
        @goto line30
    end
    INIT = 0
    (INIT,PHIR,PHII,ZETA1R,ZETA1I,ZETA2R,ZETA2I,SUMR,SUMI) = ZUNIK(ZRR,ZRI,GNU,IKFLG,1,TOL,INIT,PHIR,PHII,ZETA1R,ZETA1I,ZETA2R,ZETA2I,SUMR,SUMI,CWRKR,CWRKI)
    CZR = -ZETA1R + ZETA2R
    CZI = -ZETA1I + ZETA2I
    @goto line50
    @label line30
    ZNR = ZRI
    ZNI = -ZRR
    if ZI > 0.0
        @goto line40
    end
    ZNR = -ZNR
    @label line40
    (PHIR,PHII,ARGR,ARGI,ZETA1R,ZETA1I,ZETA2R,ZETA2I,ASUMR,ASUMI,BSUMR,BSUMI) = ZUNHJ(ZNR,ZNI,GNU,1,TOL,PHIR,PHII,ARGR,ARGI,ZETA1R,ZETA1I,ZETA2R,ZETA2I,ASUMR,ASUMI,BSUMR,BSUMI)
    CZR = -ZETA1R + ZETA2R
    CZI = -ZETA1I + ZETA2I
    AARG = ZABS(COMPLEX(ARGR,ARGI))
    @label line50
    if KODE == 1
        @goto line60
    end
    CZR = CZR - ZBR
    CZI = CZI - ZBI
    @label line60
    if IKFLG == 1
        @goto line70
    end
    CZR = -CZR
    CZI = -CZI
    @label line70
    APHI = ZABS(COMPLEX(PHIR,PHII))
    RCZ = CZR
    if RCZ > ELIM
        @goto line210
    end
    if RCZ < ALIM
        @goto line80
    end
    RCZ = RCZ + DLOG(APHI)
    if IFORM == 2
        RCZ = (RCZ - 0.25 * DLOG(AARG)) - AIC
    end
    if RCZ > ELIM
        @goto line210
    end
    @goto line130
    @label line80
    if RCZ < -ELIM
        @goto line90
    end
    if RCZ > -ALIM
        @goto line130
    end
    RCZ = RCZ + DLOG(APHI)
    if IFORM == 2
        RCZ = (RCZ - 0.25 * DLOG(AARG)) - AIC
    end
    if RCZ > -ELIM
        @goto line110
    end
    @label line90
    for I = 1:NN
        YR[I] = ZEROR
        YI[I] = ZEROI
        @label line100
    end
    NUF = NN
    return NUF
    @label line110
    ASCLE = (1000.0D1MACH1) / TOL
    (STR,STI,IDUM) = ZLOG(PHIR,PHII,STR,STI,IDUM)
    CZR = CZR + STR
    CZI = CZI + STI
    if IFORM == 1
        @goto line120
    end
    (STR,STI,IDUM) = ZLOG(ARGR,ARGI,STR,STI,IDUM)
    CZR = (CZR - 0.25STR) - AIC
    CZI = CZI - 0.25STI
    @label line120
    AX = DEXP(RCZ) / TOL
    AY = CZI
    CZR = AX * DCOS(AY)
    CZI = AX * DSIN(AY)
    (NW,) = ZUCHK(CZR,CZI,NW,ASCLE,TOL)
    if NW != 0
        @goto line90
    end
    @label line130
    if IKFLG == 2
        return NUF
    end
    if N == 1
        return NUF
    end
    @label line140
    GNU = FNU + DBLE(FLOAT(NN - 1))
    if IFORM == 2
        @goto line150
    end
    INIT = 0
    (INIT,PHIR,PHII,ZETA1R,ZETA1I,ZETA2R,ZETA2I,SUMR,SUMI) = ZUNIK(ZRR,ZRI,GNU,IKFLG,1,TOL,INIT,PHIR,PHII,ZETA1R,ZETA1I,ZETA2R,ZETA2I,SUMR,SUMI,CWRKR,CWRKI)
    CZR = -ZETA1R + ZETA2R
    CZI = -ZETA1I + ZETA2I
    @goto line160
    @label line150
    (PHIR,PHII,ARGR,ARGI,ZETA1R,ZETA1I,ZETA2R,ZETA2I,ASUMR,ASUMI,BSUMR,BSUMI) = ZUNHJ(ZNR,ZNI,GNU,1,TOL,PHIR,PHII,ARGR,ARGI,ZETA1R,ZETA1I,ZETA2R,ZETA2I,ASUMR,ASUMI,BSUMR,BSUMI)
    CZR = -ZETA1R + ZETA2R
    CZI = -ZETA1I + ZETA2I
    AARG = ZABS(COMPLEX(ARGR,ARGI))
    @label line160
    if KODE == 1
        @goto line170
    end
    CZR = CZR - ZBR
    CZI = CZI - ZBI
    @label line170
    APHI = ZABS(COMPLEX(PHIR,PHII))
    RCZ = CZR
    if RCZ < -ELIM
        @goto line180
    end
    if RCZ > -ALIM
        return NUF
    end
    RCZ = RCZ + DLOG(APHI)
    if IFORM == 2
        RCZ = (RCZ - 0.25 * DLOG(AARG)) - AIC
    end
    if RCZ > -ELIM
        @goto line190
    end
    @label line180
    YR[NN] = ZEROR
    YI[NN] = ZEROI
    NN = NN - 1
    NUF = NUF + 1
    if NN == 0
        return NUF
    end
    @goto line140
    @label line190
    ASCLE = (1000.0D1MACH1) / TOL
    (STR,STI,IDUM) = ZLOG(PHIR,PHII,STR,STI,IDUM)
    CZR = CZR + STR
    CZI = CZI + STI
    if IFORM == 1
        @goto line200
    end
    (STR,STI,IDUM) = ZLOG(ARGR,ARGI,STR,STI,IDUM)
    CZR = (CZR - 0.25STR) - AIC
    CZI = CZI - 0.25STI
    @label line200
    AX = DEXP(RCZ) / TOL
    AY = CZI
    CZR = AX * DCOS(AY)
    CZI = AX * DSIN(AY)
    (NW,) = ZUCHK(CZR,CZI,NW,ASCLE,TOL)
    if NW != 0
        @goto line180
    end
    return NUF
    @label line210
    NUF = -1
    return NUF
end
