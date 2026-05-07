import abilityTest from './LLT/Ability.test';
import bugTest from './LLT/bug.test';
import aTest from './LLT/a.test';
import CustomInlineTagTest from './HLT/CustomInlineTag.test';
import CustomParserTest from './HLT/CustomParser.test';
import DefaultParserTest from './HLT/DefaultParser.test';
import HybridParserTest from './HLT/HybridParser.test';
import SourceSpanTest from './HLT/SourceSpan.test';

export default function testsuite() {
  //LLT
  abilityTest();
  bugTest()
  aTest()
  //HLT
  DefaultParserTest();
  CustomParserTest();
  CustomInlineTagTest();
  HybridParserTest();
  SourceSpanTest();
}