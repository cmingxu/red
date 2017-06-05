$(document).ready(function(){
  var cpuLabels = [];
  var cpuData = [];
  var memoryLabels = [];
  var memoryData = [];
  var networkLabels = [];
  var networkTxData = [];
  var networkRxData = [];
  for (var i = 0; i < 20; i++) {
    cpuLabels.push('');
    cpuData.push(0);
    memoryLabels.push('');
    memoryData.push(0);
    networkLabels.push('');
    networkTxData.push(0);
    networkRxData.push(0);
  }
  var cpuDataset = { // CPU Usage
    fillColor: 'rgba(151,187,205,0.5)',
    strokeColor: 'rgba(151,187,205,1)',
    pointColor: 'rgba(151,187,205,1)',
    pointStrokeColor: '#fff',
    data: cpuData
  };
  var memoryDataset = {
    fillColor: 'rgba(151,187,205,0.5)',
    strokeColor: 'rgba(151,187,205,1)',
    pointColor: 'rgba(151,187,205,1)',
    pointStrokeColor: '#fff',
    data: memoryData
  };
  var networkRxDataset = {
    label: 'Rx Bytes',
    fillColor: 'rgba(151,187,205,0.5)',
    strokeColor: 'rgba(151,187,205,1)',
    pointColor: 'rgba(151,187,205,1)',
    pointStrokeColor: '#fff',
    data: networkRxData
  };
  var networkTxDataset = {
    label: 'Tx Bytes',
    fillColor: 'rgba(255,180,174,0.5)',
    strokeColor: 'rgba(255,180,174,1)',
    pointColor: 'rgba(255,180,174,1)',
    pointStrokeColor: '#fff',
    data: networkTxData
  };

  Chart.defaults.global.animationSteps = 30; // Lower from 60 to ease CPU load.
  var cpuChart = Chart.Line($('#cpu-stats-chart').get(0).getContext('2d'), {
    labels: cpuLabels,
    datasets: [cpuDataset]
  }, {
    responsive: true
  });

  var memoryChart = Chart.Line($('#memory-stats-chart').get(0).getContext('2d'), {
    labels: memoryLabels,
    datasets: [memoryDataset]
  },
    {
      scaleLabel: function (valueObj) {
        return humansizeFilter(parseInt(valueObj.value, 10), 2);
      },
      responsive: true
      //scaleOverride: true,
      //scaleSteps: 10,
      //scaleStepWidth: Math.ceil(initialStats.memory_stats.limit / 10),
      //scaleStartValue: 0
    });
  var networkChart = Chart.Line($('#network-stats-chart').get(0).getContext('2d'), {
    labels: networkLabels,
    datasets: [networkRxDataset, networkTxDataset]
  }, {
    scaleLabel: function (valueObj) {
      return humansizeFilter(parseInt(valueObj.value, 10), 2);
    },
    responsive: true
  });



  function updateCpuChart(data) {
    //cpuChart.addData([calculateCPUPercent(data)], new Date(data.read).toLocaleTimeString());
    cpuChart.removeData();
  }

  function updateMemoryChart(data) {
    //memoryChart.addData([data.memory_stats.usage], new Date(data.read).toLocaleTimeString());
    memoryChart.removeData();
  }

  var lastRxBytes = 0, lastTxBytes = 0;

  function updateNetworkChart(data) {
    // 1.9+ contains an object of networks, for now we'll just show stats for the first network
    // TODO: Show graphs for all networks
    if(data.network) {
      var rxBytes = 0, txBytes = 0;
      if (lastRxBytes !== 0 || lastTxBytes !== 0) {
        // These will be zero on first call, ignore to prevent large graph spike
        rxBytes = data.network.rx_bytes - lastRxBytes;
        txBytes = data.network.tx_bytes - lastTxBytes;
      }
      lastRxBytes = data.network.rx_bytes;
      lastTxBytes = data.network.tx_bytes;
      networkChart.addData([rxBytes, txBytes], new Date(data.read).toLocaleTimeString());
      networkChart.removeData();
    }
  }

  function calculateCPUPercent(stats) {
    // Same algorithm the official client uses: https://github.com/docker/docker/blob/master/api/client/stats.go#L195-L208
    var prevCpu = stats.precpu_stats;
    var curCpu = stats.cpu_stats;

    var cpuPercent = 0.0;

    // calculate the change for the cpu usage of the container in between readings
    var cpuDelta = curCpu.cpu_usage.total_usage - prevCpu.cpu_usage.total_usage;
    // calculate the change for the entire system between readings
    var systemDelta = curCpu.system_cpu_usage - prevCpu.system_cpu_usage;

    if (systemDelta > 0.0 && cpuDelta > 0.0) {
      cpuPercent = (cpuDelta / systemDelta) * curCpu.cpu_usage.percpu_usage.length * 100.0;
    }
    return cpuPercent;
  }


  function updateStats(path) {
    console.log("11111111");
    axios.get(path, {}).then(function (response) {
      var d = response.data;
      var arr = Object.keys(d).map(function (key) {
        return d[key];
      });
      // Update graph with latest data
      updateCpuChart(d);
      updateMemoryChart(d);
      updateNetworkChart(d);
      setUpdateStatsTimeout();
    }, function (response) {
      setUpdateStatsTimeout();
    });

  }

  setUpdateStatsTimeout = function () {
    setTimeout(function () {
    updateStats("/nodes/2/containers/5e0d0fdf577cb35643b8407c1c491a5f79377acfbea98a44423c67a186d85b12/stats_json");
    }, 3000);
  }

  setUpdateStatsTimeout();
});

