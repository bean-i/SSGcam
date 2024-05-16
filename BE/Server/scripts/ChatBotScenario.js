const mongoose = require('mongoose');
const { ChatBot } = require('./models/ChatBot'); 

mongoose.connect(config.mongoURI, {
}).then(() => console.log('MongoDB Connected...'))
  .catch(err => console.log(err))

const addScenario = async () => {
  const newScenario = new ChatBot({
    scenario_id: 'fraudPrevention', 
    scenario_answer: '사기를 당했을 경우, 가장 먼저 해야 할 일은 가까운 경찰서에 신고하는 것입니다. 이후, 해당 거래가 이루어진 은행이나 결제 서비스에 연락하여 사기 사실을 알리고, 가능하다면 거래를 취소하도록 요청해야 합니다.'
  });

  try {
    await newScenario.save();
    console.log('새로운 시나리오가 추가되었습니다.');
    mongoose.disconnect();
  } catch (error) {
    console.error('시나리오 추가 중 오류가 발생했습니다:', error);
    mongoose.disconnect();
  }
};

addScenario();
