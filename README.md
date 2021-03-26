# react-native-dt-picker

This date picker lets you exclude certain days in a week

## Installation

```sh
npm install react-native-dt-picker
```

## Usage

```js
import DtPicker from 'react-native-dt-picker';

// ...

<DtPicker
  hint="select a date"
  dateFormat="MM/dd/yyyy"
  restrictedDays={[1, 2, 7]}
  onDateChanged={(e) => console.log('on change', e.nativeEvent.text)}
  style={{
    height: 30,
    backgroundColor: 'white',
    width: 100,
  }}
/>;
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
