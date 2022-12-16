/*
REQUIREMENT / BAHAN RACIKAN
	SAKTIKSL.MV_GLP_BUKU_BESAR_220930_221110
	SPAN.MV_PAYMENTS_220930_221109
	SPAN.MV_KONTRAK_220930_221109
*/
DROP materialized view SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023;
CREATE materialized view SAKTIKSL.mv_DESKRIPSI_SP2D_220930_221023
--Additional filters
PARALLEL 4
AS
select	base.*,
		BAST.JUMLAH_BARANG			AS BAST_JUMLAH_BARANG,
		BAST.TOTAL_HARGA			AS BAST_TOTAL_HARGA,
		BAST.JML_BAST				AS BAST_JML_BAST,
--		BAST.TGL_BAST,
		BAST.SUMBER_HEAD
from
(	SELECT	GLP.ID						ID_GLP,
			GLP.KODE_BA_SATKER,
			GLP.NAMA_BA_SATKER,
			GLP.KODE_ESELON1_SATKER,
			GLP.NAMA_ESELON1_SATKER,
			GLP.KODE_SATKER,
			GLP.NAMA_SATKER,
			GLP.KODE_FUNGSI,
			GLP.NAMA_FUNGSI,
			GLP.KODE_SUB_FUNGSI,
			GLP.NAMA_SUBFUNGSI,
			GLP.KODE_PROGRAM,
			GLP.NAMA_PROGRAM,
			GLP.KODE_KEGIATAN,
			GLP.NAMA_KEGIATAN,
			GLP.KODE_OUTPUT,
			GLP.NAMA_OUTPUT,
			GLP.KAS,
			GLP.UR_KAS,
			GLP.DIVALIDASI,
			GLP.UR_DIVALIDASI,
			GLP.JENIS_DOKUMEN,
			GLP.KODE_SDATA,
			GLP.KODE_BUKU_BESAR,
			GLP.KODE_JURNAL,
			GLP.KODE_PROPINSI_SATKER,
			GLP.NAMA_PROPINSI_SATKER,
			GLP.KODE_KOTA_SATKER,
			GLP.NAMA_KOTA_SATKER,
			GLP.KODE_KPPN,
			TRIM(GLP.NAMA_KPPN)			NAMA_KPPN,
			GLP.KODE_AKUN,
			TRIM(GLP.NAMA_AKUN)			NAMA_AKUN,
			GLP.DEBET,
			GLP.KREDIT,
			GLP.NO_DOK,
			GLP.TGL_DOK,
			GLP.NTPN_SP2D,
			GLP.SPM_SSBP,
			GLP.DESKRIPSI_TRANS,
			GLP.KODE_MATA_UANG_TRANS,
			GLP.KURS,
			GLP.NILAI_TRANS_VALAS,
			GLP.KODE_CARA_TARIK,
			GLP.NAMA_CARA_TARIK,
			GLP.KODE_PERIODE,
			GLP.KODE_REGISTER,
			GLP.NAMA_PINJAMAN_HIBAH,
			GLP.NAMA_DONOR,
			GLP.KODE_SUMBER_DANA,
			GLP.NAMA_SUMBER_DANA,
			GLP.KODE_TIPE_BUDGET,
			GLP.NAMA_TIPE_BUDGET,
			GLP.NOMOR_DIPA,
			GLP.TGL_JURNAL,
			GLP.KODE_KOROLARI,
			GLP.UR_KODE_KOROLARI,
			GLP.TIPE_MONITORING_JURNAL,
			GLP.UR_TIPE_MONITORING_JURNAL,
			PAY.VENDOR_NAME_ALT			AS NAMA_REKANAN,
			PAY.vendor_type				AS TIPE_REKANAN,									--Edit 13 Jan 2021
			PAY.DESCRIPTION				AS DESKRIPSI,
			PAY.SPPM_JENIS_DOKUMEN		AS JENDOK,
			PAY.INVOICE_NUM				AS NO_SPM,
			PAY.INVOICE_DATE			AS TGL_SPM,
			PAY.INVOICE_AMOUNT			AS NILAI_SPM,
			PAY.INVOICE_CURRENCY_CODE	AS SPM_CURRENCY,
			PAY.PAYMENT_CURRENCY_CODE	AS SP2D_CURRENCY,
			PAY.PAYMENT_CROSS_RATE		AS SP2D_KURS,
			PAY.STATUS_LOOKUP_CODE,
			PAY.AMOUNT_PAID,
			PAY.INVOICE_TYPE_LOOKUP_CODE,
			KON.CLOSED_CODE, 
			KON.PO_CATEGORY 			AS CATEGORY, 
			KON.PO_NO_KONTRAK 			AS NO_KONTRAK, 
			KON.PO_KETERANGAN			AS KETERANGAN, 
			TO_DATE(SUBSTR(KON.po_TGL_KONTRAK,1,10),'YYYY/MM/DD')		AS TGL_KONTRAK, 
			TO_DATE(SUBSTR(KON.po_KONTRAK_START,1,10),'YYYY/MM/DD')		AS KONTRAK_START,
			TO_DATE(SUBSTR(KON.po_KONTRAK_END,1,10),'YYYY/MM/DD')		AS KONTRAK_END, 
			KON.po_NO_CAN				AS NO_CAN,
			KON.po_NO_ADDENDUM			AS NO_ADDENDUM, 
			KON.po_no_dipa 				AS NODIPA, 
			KON.po_KET_LAIN 			AS KETLAIN, 
			KON.po_global_attr1 		AS ATTR1, 
			KON.EMAIL_ADDRESS, 
			KON.NILAI_KONTRAK, 
			KON.RCV_NPWP 				AS NPWP, 
			KON.RCV_NIP 				AS NIP, 
			KON.rcv_NAMA_TERIMA			AS NAMA_TERIMA, 
			KON.RCV_NOREK 				AS NOREK, 
			KON.rcv_NAMA_REK 			AS NAMA_REK, 
			KON.RCV_BANK 				AS BANK, 
			KON.RCV_RKBUN 				AS RKBUN, 
			KON.RCV_BIC 				AS BIC, 
			KON.RCV_FOREIGNBANK 		AS FOREIGNBANK,
			KON.NM_LOKASI				AS NM_LOKASI,										--Edit 18 Jan 2021
			KON.AILA_DESKRIPSI			AS TERMIN,											--Edit 18 Jan 2021
			KON.NILAI_BELANJA,
			KON.NILAI_POTONGAN,
			SPM.ID_SPP,
			SPM.NO_REG_INV				AS NO_REG_INV_SPM,
			SPM.DELETED					AS DELETED_SPM,
			SPM.STS_DATA				AS STS_DATA_SPM,
			spm.ur_sts_data				AS UR_STS_DATA_SPM,
			SPM.JML_PEMBAYARAN			AS JML_PEMBAYARAN_SPM,
			SPM.JML_PENGELUARAN			AS JML_PENGELUARAN_SPM,
			SPM.JML_POTONGAN			AS JML_POTONGAN_SPM,
			SPM.URAIAN					AS URAIAN_SPM,
			SPM.NO_KONTRAK				AS NO_KONTRAK_SPM,
			SPM.STATUS_APD				AS STATUS_APD_SPM,
			SPM.ur_STATUS_APD			AS UR_STATUS_APD_SPM,
			SPM.KOREKSI_FLAG			AS FLAG_KOREKSI_SPM
	FROM 
	(	SELECT	*
		FROM	SAKTIKSL.MV_GLP_BUKU_BESAR_220930_221023
		WHERE	KAS = '1'																	--Edit 11 Nov 2022
				and DIVALIDASI = '1'
				AND SUBSTR (KODE_AKUN,1,1) IN ('5')	
	) GLP
	LEFT JOIN	SPAN.MV_PAYMENTS_220930_221109 PAY
			ON	to_char(GLP.NTPN_SP2D) = to_char(PAY.CHECK_NUMBER) 
				and GLP.KODE_SATKER = substr(PAY.INVOICE_NUM,8,6)							--Edit 8 May 2021
	LEFT JOIN	SPAN.MV_KONTRAK_220930_221109 KON
			ON	to_char(GLP.NTPN_SP2D) = to_char(KON.NO_SP2D)
				and GLP.KODE_AKUN = KON.KD_AKUN
				and GLP.KODE_SATKER = KON.KD_SATKER											--Edit 8 May 2021
	LEFT JOIN	
	(	SELECT	DISTINCT ID		ID_SPP,
				DELETED,
				NO_REG_INV,
				KD_SATKER,
				NO_SPP,
				NO_SP2D,
				NO_KONTRAK,
				STS_DATA,
				case	when sts_data = 'SPM_STS_DATA_01' then 'Baru'
						when sts_data = 'SPM_STS_DATA_02' then 'Cetak SPP'
						when sts_data = 'SPM_STS_DATA_03' then 'Batal SPP'
						when sts_data = 'SPM_STS_DATA_04' then 'Setuju SPP'
						when sts_data = 'SPM_STS_DATA_05' then 'ADK SPP'
						when sts_data = 'SPM_STS_DATA_06' then 'Batal ADK SPP'
						when sts_data = 'SPM_STS_DATA_07' then 'Upload NTT'
						when sts_data = 'SPM_STS_DATA_08' then 'Cetak SPM'
						when sts_data = 'SPM_STS_DATA_09' then 'Batal SPM'
						when sts_data = 'SPM_STS_DATA_10' then 'Setuju SPM'
						when sts_data = 'SPM_STS_DATA_11' then 'ADK SPM'
						when sts_data = 'SPM_STS_DATA_12' then 'Batal ADK SPM'
						when sts_data = 'SPM_STS_DATA_13' then 'Upload SP2D'
						when sts_data = 'SPM_STS_DATA_14' then 'Permohonan Pembatalan ADK SPM'
						when sts_data = 'SPM_STS_DATA_15' then 'Void SP2D'
					end as ur_sts_data,
				JML_PEMBAYARAN,
				JML_PENGELUARAN,
				JML_POTONGAN,
				URAIAN,
				STATUS_APD,
				case	when STATUS_APD = '1' then 'UM'
						when STATUS_APD = '2' then 'KONTRAK'
						when STATUS_APD = '3' then 'RETENSI'
					end as ur_STATUS_APD,
				KOREKSI_FLAG
		FROM	SAKTIKSL.BPK_SPM_T_SPP_220930_221023
		WHERE	DELETED != '1'
	) SPM
			ON	GLP.NTPN_SP2D = SPM.NO_SP2D
				AND GLP.KODE_SATKER = SPM.KD_SATKER
) base
LEFT JOIN	
(	SELECT	SUM(JUMLAH_BARANG)		JUMLAH_BARANG,
			SUM(TOTAL_HARGA)		TOTAL_HARGA,
			COUNT(DISTINCT NO_BAST)	JML_BAST,
			KODE_SATKER,
--			TGL_BAST,
			SPP_ID,
			SUMBER_HEAD
	FROM	SAKTIKSL.MV_KOM_BAST_ALL_220930_221023
	WHERE	DELETED_DETAIL != '1'
			AND DELETED_HEADER != '1'
	GROUP BY	KODE_SATKER,
--				TGL_BAST,
				SPP_ID,
				SUMBER_HEAD
) BAST
		ON	BASE.ID_SPP = BAST.SPP_ID
			AND BASE.KODE_SATKER = BAST.KODE_SATKER
;
CREATE INDEX SAKTIKSL.IDX_DESP22221023_KDBA ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023(KODE_BA_SATKER) PARALLEL 2 ;
create index saktiksl.IDX_DESP22221023_KDES1 ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023(KODE_BA_SATKER||kode_eselon1_satker) PARALLEL 2;
CREATE INDEX SAKTIKSL.IDX_DESP22221023_NODOK1 ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023(NTPN_SP2D) PARALLEL 2 ;
CREATE INDEX SAKTIKSL.IDX_DESP22221023_satker ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023 (KODE_SATKER) PARALLEL 2;
-- CREATE INDEX SAKTIKSL.IDX_DESP22221023_prog ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023 (KODE_PROGRAM) PARALLEL 2;
-- CREATE INDEX SAKTIKSL.IDX_DESP22221023_giat ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023 (KODE_KEGIATAN) PARALLEL 2;
-- CREATE INDEX SAKTIKSL.IDX_DESP22221023_out ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023 (KODE_OUTPUT) PARALLEL 2;
CREATE INDEX SAKTIKSL.IDX_DESP22221023_KKUN ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023 (KODE_AKUN) PARALLEL 2;
CREATE INDEX SAKTIKSL.IDX_DESP22221023_kontrak ON SAKTIKSL.MV_DESKRIPSI_SP2D_220930_221023 (no_kontrak) PARALLEL 2;