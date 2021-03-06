require_relative '../../model/rule/rulesvb'

class RulesVBCtrl
  def initialize
    @rulesvbs = Array.new
  end

  def extractData(sheets)
    MdDb::RunDB.connect()

    for row in sheets
      next if row.index_in_collection == 0 ||
      (row[MdSheet::RulesVBSheet::IDX_CODE] == nil || row[MdSheet::RulesVBSheet::IDX_CODE].value == nil) ||
      (row[MdSheet::RulesVBSheet::IDX_CODE_RULE] == nil || row[MdSheet::RulesVBSheet::IDX_CODE_RULE].value == nil) ||
      (row[MdSheet::RulesVBSheet::IDX_CODE_VERB] == nil || row[MdSheet::RulesVBSheet::IDX_CODE_VERB].value == nil)

      rulesVBModel = RulesVBModel.new
      rulesVBModel.setCode(row[MdSheet::RulesVBSheet::IDX_CODE])

      ruleId = MdDb::DBUtil::INSTANCE.getIdDb(MdSheet::RuleSheet::NAME,
        MdDb::DBUtil::INSTANCE.getCodeFormat(row[MdSheet::RulesVBSheet::IDX_CODE_RULE].value()))
      rulesVBModel.setRuleId(ruleId)

      verbId = MdDb::DBUtil::INSTANCE.getIdDb(MdSheet::VerbSheet::NAME,
        MdDb::DBUtil::INSTANCE.getCodeFormat(row[MdSheet::RulesVBSheet::IDX_CODE_VERB].value()))
      rulesVBModel.setVerbId(verbId)

      @rulesvbs.push(rulesVBModel)
    end

    MdDb::RunDB.closeConnection()
  end

  def persistData()
    MdDb::RunDB.connect()

    for rulesvb in @rulesvbs

      code = MdDb::DBUtil::INSTANCE.getCodeFormat(rulesvb.getCode().value)
      params = [code, rulesvb.getRuleId(), rulesvb.getVerbId()]

      MdDb::RunDB.persistData(MdSheet::RulesVBSheet::NAME, rulesvb.to_s, params)
    end

    MdDb::RunDB.closeConnection()
  end

  def showDataXls()
    for rulesvb in @rulesvbs
      puts rulesvb.getCode()
      puts rulesvb.getRuleId()
      puts rulesvb.getVerbId()
    end
  end
end
